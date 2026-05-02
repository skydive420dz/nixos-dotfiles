# ============================================
# AUDIO CONFIGURATION — NixOS / PipeWire
# ============================================
# Hardware (fully confirmed via pactl, pw-cli, codec pin inspection):
#
#   pci-0000_01_00.1  — NVIDIA AD107 HDMI audio       (off, unused)
#   pci-0000_05_00.1  — Radeon HDMI audio              (off, unused)
#   pci-0000_05_00.6  — Ryzen HD Audio / Realtek ALC256
#                         Codec: HDA:10ec0256,146213dd
#                         Node 0x19: Pink jack — only mic input on this laptop
#                         Node 0x21: Green jack — headphone output
#                         No internal mic capsule (confirmed by codec pin map)
#   pci-0000_06_00.0  — USB webcam (video only, no audio)
#
# Mic availability:
#   Pink jack mic  → available when a mic or headset is plugged in
#   Bluetooth mic  → available when a BT headset is connected (HFP profile)
#   No always-on mic exists on this hardware
#
# Device priority ladder (session):
#   4000 — bluetooth output  (wins as default sink when connected)
#   3500 — pink jack mic + board output  (system defaults when no BT)
#    500 — bluetooth mic  (selectable in WireMix, never auto-steals)
#
# Bluetooth control surface:
#   Volume keys     → follow default sink → follow connected BT device
#   Device volume   → synced via bluez5.enable-hw-volume (absolute volume)
#   Tap/squeeze/    → AVRCP → mpris-proxy → MPRIS → media player
#     skip controls
#   Battery report  → BlueZ Experimental (AirPods, Sony, etc.)

{ config, pkgs, ... }:

{
  hardware.enableAllFirmware = true; # ALC256 / Ryzen HDA firmware blobs
  security.rtkit.enable = true; # Real-time scheduling for PipeWire

  # ── Bluetooth stack ────────────────────────────────────────────────────────
  # Experimental = battery reporting for AirPods and similar.
  # KernelExperimental = better codec negotiation and reconnect behaviour.
  # ControllerMode dual = ensures AVRCP version supporting absolute volume.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        KernelExperimental = true;
        ControllerMode = "dual";
      };
    };
  };

  # ── mpris-proxy ────────────────────────────────────────────────────────────
  # Bridges Bluetooth AVRCP transport commands (tap/squeeze/skip from the
  # device) to the MPRIS D-Bus interface used by Spotify, Firefox, mpv, etc.
  # Without this, in-ear/on-ear controls do nothing on Linux.
  #
  # bluez already ships a user unit at:
  #   $out/etc/systemd/user/mpris-proxy.service
  # so we don't redefine it here (a duplicate ExecStart breaks the unit).
  # Enable it once per user with:
  #   systemctl --user enable --now mpris-proxy

  services.pipewire = {
    enable = true;

    # ── Compatibility layers ──────────────────────────────────────────────────
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Steam / Wine / 32-bit games

    wireplumber.extraConfig = {

      # ── 10: ALSA device/node rules ─────────────────────────────────────────
      "10-hardware-nodes" = {
        "monitor.alsa.rules" = [

          # ── Ryzen ALC256 card-level ───────────────────────────────────────
          # Matched on the CARD so ACP device props apply before nodes spawn.
          # auto-port    = false → don't honour jack-detect port availability
          #                        events (prevents mic node teardown on plug)
          # auto-profile = false → hold duplex profile permanently; don't let
          #                        ACP switch profiles on jack plug/unplug
          {
            matches = [
              { "device.name" = "alsa_card.pci-0000_05_00.6"; }
            ];
            actions.update-props = {
              "api.alsa.use-acp" = true;
              "api.acp.auto-port" = false;
              "api.acp.auto-profile" = false;
              "device.profile" = "output:analog-stereo+input:analog-stereo";
              "device.description" = "Ryzen ALC256 (laptop audio)";
            };
          }

          # ── Pink jack — mic input ─────────────────────────────────────────
          # The only mic source on this laptop.
          # Available when a mic or TRRS headset is plugged into the pink jack.
          # System default source — WireMix shows it at the top of the list.
          {
            matches = [
              { "node.name" = "alsa_input.pci-0000_05_00.6.analog-stereo"; }
            ];
            actions.update-props = {
              "priority.session" = 3500;
              "node.description" = "Mic jack (pink)";
            };
          }

          # ── Green jack — headphone / speaker output ───────────────────────
          # Single output node serving both the internal speakers and the
          # green headphone jack. Hardware auto-routes to headphones when
          # plugged in (codec jack-detect on output side is intentional).
          {
            matches = [
              { "node.name" = "alsa_output.pci-0000_05_00.6.analog-stereo"; }
            ];
            actions.update-props = {
              "priority.session" = 3500;
              "node.description" = "Laptop audio out (speakers / headphones)";
            };
          }

        ];
      };

      # ── 10: Bluetooth node rules ───────────────────────────────────────────
      # BlueZ nodes come from monitor.bluez, NOT monitor.alsa — they need
      # their own rules block. Putting BT matches inside monitor.alsa.rules
      # silently does nothing (the rules never run against BlueZ nodes),
      # leaving them at the WirePlumber default priority of ~1010.
      "10-bluetooth-nodes" = {
        "monitor.bluez.rules" = [

          # ── Bluetooth audio outputs ───────────────────────────────────────
          # Priority 4000 — any connected BT output wins as the default sink.
          # This means volume keys, media controls, and new streams all
          # automatically follow the BT device. When it disconnects, the
          # laptop output (priority 3500) takes over again.
          #
          # absolute-volume = true → device-side volume (AirPods crown,
          # headphone +/- buttons) syncs with the system slider.
          {
            matches = [
              { "node.name" = "~bluez_output.*"; }
            ];
            actions.update-props = {
              "priority.session" = 4000;
              "bluez5.a2dp.absolute-volume" = true;
            };
          }

          # ── Bluetooth mic inputs ──────────────────────────────────────────
          # Appear in WireMix when a BT headset connects.
          # Priority 500 — never auto-steal the default source.
          {
            matches = [
              { "node.name" = "~bluez_input.*"; }
            ];
            actions.update-props = {
              "priority.session" = 500;
            };
          }

        ];
      };

      # ── 10: Bluetooth codec policy ────────────────────────────────────────
      "10-bluetooth-codecs" = {
        "monitor.bluez.properties" = {
          # Negotiation order: AAC first (best for AirPods), then SBC-XQ,
          # then standard SBC. mSBC/CVSD are for HFP voice calls only.
          "bluez5.codecs" = [
            "aac"
            "sbc_xq"
            "sbc"
            "msbc"
            "cvsd"
          ];

          # Sync hardware volume with desktop OSD / volume keys
          "bluez5.enable-hw-volume" = true;

          "bluez5.roles" = [
            "a2dp_sink" # receive high-quality stereo (AirPods as output)
            "a2dp_source" # send audio to a BT speaker
            "hsp_hs" # headset profile (mono audio + mic)
            "hsp_ag"
            "hfp_hf" # hands-free / call mic
            "hfp_ag"
          ];
        };
      };

      # ── 11: Bluetooth session policy ──────────────────────────────────────
      "11-bluetooth-policy" = {
        "wireplumber.settings" = {
          # Offer headset profile (mic enabled) immediately on BT connect
          # so the BT mic appears in WireMix without manual profile switching.
          "bluetooth.autoswitch-to-headset-profile" = true;
        };
      };

      # ── 99: Persistent defaults ───────────────────────────────────────────
      # Uses node NAMES not IDs — stable across reboots.
      # Pink jack = default source (available when mic plugged in).
      # Board output = default sink (headphones auto-switch at hardware level).
      "99-defaults" = {
        "wireplumber.settings" = {
          "default.audio.source" = "alsa_input.pci-0000_05_00.6.analog-stereo";
          "default.audio.sink" = "alsa_output.pci-0000_05_00.6.analog-stereo";
        };
      };

    };

    # ── PipeWire graph / clock settings ──────────────────────────────────────
    extraConfig.pipewire = {

      # Silence the X11 bell (prevents jarring beep through speakers).
      "99-silent-bell" = {
        "context.properties"."module.x11.bell" = false;
      };

      # Clock pool: PipeWire matches the active sink's native rate so content
      # is never double-resampled. A 44.1 kHz file stays at 44.1 kHz; a
      # 96 kHz DAC runs natively. Low-quality content (e.g. 8 kHz VoIP) is
      # upsampled once by the built-in sinc resampler.
      # Quantum 1024 ≈ 21 ms @ 48 kHz — stable for everyday use.
      # Lower min-quantum to 512 for music production (needs realtime kernel).
      "99-clock-pool" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            192000
          ];
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 2048;
        };
      };

    };

  };
}

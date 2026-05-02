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
#   3500 — pink jack mic + laptop output  (defaults when no BT)
#    500 — bluetooth mic  (selectable in WireMix, never auto-steals)
#
# Bluetooth:
#   GLOBAL properties (codecs, roles, enable-hw-volume) intentionally left
#   at NixOS / PipeWire defaults. Earlier attempts to set them via
#   wireplumber.extraConfig broke HFP profile registration on this setup
#   (failed to get HFP codec 127). Per-node priority overrides (via
#   monitor.bluez.rules) are safe and used below.
#
#   On-device controls (tap/squeeze/skip) are bridged to MPRIS by the
#   bluez-shipped mpris-proxy.service, enabled per user with
#   `systemctl --user enable --now mpris-proxy`.

{ config, pkgs, ... }:

{
  hardware.enableAllFirmware = true; # ALC256 / Ryzen HDA firmware blobs
  security.rtkit.enable = true; # Real-time scheduling for PipeWire

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # Often required for modern BLE devices
  };

  services.pipewire = {
    enable = true;

    # ── Compatibility layers ──────────────────────────────────────────────────
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Steam / Wine / 32-bit games

    wireplumber.extraConfig = {

      # ── 10: ALSA device/node rules ─────────────────────────────────────────
      # Scoped strictly to the ALC256 card. No BT rules here — those would
      # never match anyway (BT nodes come from monitor.bluez, not monitor.alsa)
      # and earlier attempts to customize BT via wireplumber.extraConfig broke
      # HFP profile registration on this hardware.
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
      # BlueZ nodes come from monitor.bluez, NOT monitor.alsa.
      #
      # IMPORTANT: this block uses monitor.bluez.RULES (per-node property
      # overrides) which is safe. Do NOT add monitor.bluez.PROPERTIES here —
      # that path (used to set bluez5.codecs / bluez5.roles / etc.) broke HFP
      # profile registration on this hardware. Keep BT global properties at
      # NixOS / PipeWire defaults.
      "10-bluetooth-priority" = {
        "monitor.bluez.rules" = [

          # Any connected BT output wins as the default sink.
          # Priority 4000 > laptop output's 3500, so volume keys, media
          # controls, and new streams automatically follow the BT device.
          # When the BT device disconnects, the laptop output takes over.
          {
            matches = [
              { "node.name" = "~bluez_output.*"; }
            ];
            actions.update-props = {
              "priority.session" = 4000;
            };
          }

          # BT mics stay below the pink jack mic so they never auto-steal
          # the default source. Selectable in WireMix when needed.
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

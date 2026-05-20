{
  services.libinput.enable = true;

  services.keyd.enable = false;

  services.udev.extraRules = ''
    # DrunkDeer configuration uses vendor HID reports over hidraw. Keep this
    # scoped to DrunkDeer devices so drunkdeerctl can probe without sudo.
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="352d", MODE="0660", GROUP="input", TAG+="uaccess"
  '';

  services.kanata = {
    enable = true;

    keyboards.internal = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc
          caps y p IntlBackslash)

        (defalias
          capsmod (tap-hold 200 200 esc (multi lctl lalt (layer-while-held controlalt)))
          copy (multi (release-key lalt) C-c)
          paste (multi (release-key lalt) C-v))

        (deflayer base
          @capsmod _ _ bksl)

        (deflayer controlalt
          _ @copy @paste _)
      '';
    };

    keyboards.drunkdeer = {
      devices = [ "/dev/input/by-id/usb-Drunkdeer_Drunkdeer_A75_Pro_ANSI_RYMicro-event-kbd" ];
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc
          caps y p)

        (defalias
          capsmod (tap-hold 200 200 esc (multi lctl lalt (layer-while-held controlalt)))
          copy (multi (release-key lalt) C-c)
          paste (multi (release-key lalt) C-v))

        (deflayer base
          @capsmod _ _)

        (deflayer controlalt
          _ @copy @paste)
      '';
    };
  };
}

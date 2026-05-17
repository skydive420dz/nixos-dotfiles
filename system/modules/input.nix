{
  services.libinput.enable = true;

  services.keyd.enable = false;

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
  };
}

{
  services.libinput.enable = true;

  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];

      settings = {
        main = {
          capslock = "overload(controlalt, esc)";
        };

        "controlalt:C-A" = {
          y = "C-c";
          p = "C-v";
        };
      };
    };
  };
}

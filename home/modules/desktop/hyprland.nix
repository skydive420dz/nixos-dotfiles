{ repoPath, ... }:

{
  services.swayosd.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      monitorv2 = [
        {
          output = "eDP-1";
          mode = "1920x1080@144";
          position = "0x0";
          scale = 1;
          bitdepth = 10;
          sdr_eotf = "gamma22";
          sdrbrightness = 0.7;
          sdrsaturation = 1.11;
          supports_wide_color = 1;
          sdr_min_luminance = 0.001;
          sdr_max_luminance = 400;
          vrr = 1;
        }
        {
          output = "HDMI-A-1";
          mode = "3440x1440@100";
          position = "1920x0";
          scale = 1;
          bitdepth = 10;
          cm = "hdr";
          sdr_eotf = "gamma22";
          sdrbrightness = 0.86;
          sdrsaturation = 1.6;
          supports_wide_color = 1;
          supports_hdr = 1;
          sdr_min_luminance = 0.005;
          sdr_max_luminance = 450;
          vrr = 1;
        }
      ];
    };
    extraConfig = ''
      source = ~/.config/hypr/mocha.conf
      source = ${repoPath}/config/hypr/hyprland.conf
    '';
  };
}

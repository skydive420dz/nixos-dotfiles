{
  services.upower.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      RUNTIME_PM_DENYLIST = "0000:01:00.0";
      STOP_CHARGE_THRESH_BAT1 = 90;
      START_CHARGE_THRESH_BAT1 = 75;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      USB_AUTOSUSPEND = 1;
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersupersave";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
    };
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}

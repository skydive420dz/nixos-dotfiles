{ config, pkgs, ... }:

let
  openrazerKernel = config.boot.kernelPackages.openrazer.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace driver/razerkbd_driver.c \
        --replace-fail "hid_report_raw_event(hdev, HID_INPUT_REPORT, xdata, sizeof(xdata), 0);" \
                       "hid_report_raw_event(hdev, HID_INPUT_REPORT, xdata, sizeof(xdata), sizeof(xdata), 0);"
    '';
  });
in

{
  hardware.openrazer = {
    enable = true;
    users = [ "skydive420dz" ];
    packages.kernel = openrazerKernel;

    # Keep the daemon useful without collecting keypress statistics.
    keyStatistics = false;
    devicesOffOnScreensaver = true;
    batteryNotifier.enable = true;
  };

  # Piper/ratbagd is useful for general gaming mouse inspection/configuration.
  # Razer lighting/DPI is expected to go through OpenRazer/Polychromatic.
  services.ratbagd.enable = true;

  # Fallback for remapping side buttons when OpenRazer exposes the device but
  # does not provide Synapse-style button assignment.
  services.input-remapper = {
    enable = true;
    enableUdevRules = true;
  };

  environment.systemPackages = with pkgs; [
    polychromatic
    razer-cli
    piper
  ];
}

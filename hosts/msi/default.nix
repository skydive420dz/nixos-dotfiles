{
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./maintenance.nix
    ../../system/modules
    ../../system/modules/gpu/nvidia-hybrid.nix
  ];

  hardware.keyboard.qmk.enable = true;
}

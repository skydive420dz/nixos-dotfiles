{
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ../../system/modules
    ../../system/modules/gpu/nvidia-hybrid.nix
  ];

  hardware.keyboard.qmk.enable = true;
}

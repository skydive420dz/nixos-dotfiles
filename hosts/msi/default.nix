{
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./maintenance.nix
    ../../system/modules
    ../../system/modules/gpu/nvidia-hybrid.nix
  ];

  programs.nix-ld.enable = true;

  hardware.keyboard.qmk.enable = true;

  zramSwap.enable = true;
}

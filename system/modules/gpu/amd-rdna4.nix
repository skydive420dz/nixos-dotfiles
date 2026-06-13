# AMD RDNA4 desktop graphics profile.
#
# Target hardware: Radeon RX 9070 XT class desktop GPU.

{ pkgs, ... }:

{
  boot.initrd.kernelModules = [
    "amdgpu"
  ];

  boot.kernelModules = [
    "amdgpu"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  environment.systemPackages = with pkgs; [
    libva-utils
    vulkan-tools
  ];
}

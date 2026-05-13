{ hardwareConfiguration ? /etc/nixos/hardware-configuration.nix, ... }:

{
  imports = [
    hardwareConfiguration
    ../../system/modules
  ];
}

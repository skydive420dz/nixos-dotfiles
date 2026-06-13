{ lib, ... }:

{
  assertions = [
    {
      assertion = false;
      message = ''
        hosts/desktop-amd/hardware-configuration.nix is a tracked bootstrap
        placeholder.

        On the new desktop, generate the real hardware file with:

          nixos-generate-config --root /mnt --show-hardware-config \
            > hosts/desktop-amd/hardware-configuration.nix

        Because this file is tracked, the generated content will be visible to
        the local flake as a dirty tracked change during installation.
      '';
    }
  ];
}

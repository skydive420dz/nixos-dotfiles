{ pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABClAXOeEh/2GHlwyKuAq2L3EY5sZYsw/I4HlLYKokm r0liveira@icloud.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFY+QfRli3gArIR6yXju7uMfgYfMlmVkTfsXbLw6zaVa skydive420dz@nixos"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh.enable = true;
}

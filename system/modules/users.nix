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
    ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh.enable = true;
}

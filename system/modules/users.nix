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
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh.enable = true;
}

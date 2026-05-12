{ inputs, ... }:

{
  imports = [
    ./home.nix
    ./modules
    ./modules/desktop/hyprland.nix
    ./modules/programs/btop.nix
    ./modules/programs/git.nix
    ./modules/programs/waybar.nix
    ./modules/programs/zsh.nix
    ./modules/services/awww.nix
    ./modules/services/quickshell.nix
    ./modules/session.nix
  ];
}

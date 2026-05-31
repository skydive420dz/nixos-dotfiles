{ inputs, ... }:

{
  imports = [
    ./home.nix
    ./modules
    ./modules/programs/btop.nix
    ./modules/programs/git.nix
    ./modules/programs/zsh.nix
    ./modules/services/quickshell.nix
    ./modules/session.nix
  ];
}

{ pkgs, ... }:

{
  environment.systemPackages =
    let
      wlctl = pkgs.callPackage ../../pkgs/wlctl-bin.nix { };
    in
    with pkgs;
    [
      libinput
      evtest
      wev
      tmux
      kitty.terminfo
      vim
      lshw
      wget
      git
      ripgrep
      fd
      qt6.qtdeclarative
      qt6.qtbase
      qt6.qtlanguageserver

      fzf
      quickshell

      nil
      nixpkgs-fmt
      nodejs
      gcc
      c3-lsp

      fastfetch
      nitch

      (mpv.override { youtubeSupport = false; })
      cava

      bluez
      bluez-tools
      brightnessctl
      bluetui
      wlctl

      protonup-ng
      snip
    ];
}

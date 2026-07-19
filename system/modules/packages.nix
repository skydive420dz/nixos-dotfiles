{ pkgs, ... }:

{
  environment.systemPackages =
    let
      wlctl = pkgs.callPackage ../../pkgs/wlctl-bin.nix { };
    in
    with pkgs; [
      libinput
      evtest
      wev
      tmux
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

      ffmpeg-full
      mpv
      cava

      vial
      qmk
      qmk-udev-rules

      bluez
      bluez-tools
      brightnessctl
      bluetui
      wlctl

      protonup-ng
      snip
    ];
}

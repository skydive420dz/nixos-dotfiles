{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libinput
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
    fuzzel
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

    bluez
    bluez-tools
    brightnessctl
    bluetui

    protonup-ng
    snip
  ];
}

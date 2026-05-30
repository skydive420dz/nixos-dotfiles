{ config, lib, pkgs, ... }:

let
  doomDir = "${config.home.homeDirectory}/.config/doom";
  emacsDir = "${config.home.homeDirectory}/.config/emacs";
  aspellWithEnglish = pkgs.aspellWithDicts (dicts: with dicts; [
    en
  ]);
  qmlImportPaths = [
    "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    "${pkgs.quickshell}/lib/qt-6/qml"
  ];
  qmlImportArgs = lib.concatMapStringsSep " " (path: "-I ${lib.escapeShellArg path}") qmlImportPaths;
in
{
  home.packages = with pkgs; [
    emacs-pgtk

    # Core Doom/project tooling.
    git
    ripgrep
    fd
    editorconfig-core-c
    tree-sitter

    # Runtime basics and rich document support.
    sqlite
    gnutls
    imagemagick
    zstd
    unzip
    pandoc
    texliveSmall
    aspellWithEnglish
    harper

    # vterm native module support.
    libvterm
    cmake
    gnumake
    gcc
    libtool
    autoconf
    automake
    pkg-config

    # Language server support for the Emacs experiment.
    lua
    lua-language-server
    stylua
    qt6.qtlanguageserver
    rust-analyzer
    rustc
    cargo
    rustfmt
    clang-tools
    shellcheck
    shfmt
    glslang

    (writeShellScriptBin "qmlls-wrapped" ''
      exec ${qt6.qtdeclarative}/bin/qmlls ${qmlImportArgs} "$@"
    '')

    # Nix editing support for the Emacs experiment.
    nil
    nixfmt

    (writeShellScriptBin "doom-bootstrap" ''
      set -euo pipefail

      export DOOMDIR="${doomDir}"
      emacs_dir="${emacsDir}"

      if [ ! -d "$emacs_dir/.git" ]; then
        git clone --depth 1 https://github.com/doomemacs/doomemacs "$emacs_dir"
      else
        git -C "$emacs_dir" pull --ff-only
      fi

      "$emacs_dir/bin/doom" install
      "$emacs_dir/bin/doom" sync
    '')
  ];

  home.sessionPath = [
    "${emacsDir}/bin"
  ];

  home.sessionVariables = {
    DOOMDIR = doomDir;
  };
}

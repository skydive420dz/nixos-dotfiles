{
  config,
  lib,
  pkgs,
  ...
}:

let
  doomDir = "${config.home.homeDirectory}/.config/doom";
  emacsDir = "${config.home.homeDirectory}/.config/emacs";
  aspellWithEnglish = pkgs.aspellWithDicts (
    dicts: with dicts; [
      en
    ]
  );
  qmlImportPaths = [
    "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    "${pkgs.quickshell}/lib/qt-6/qml"
  ];
  qmlImportArgs = lib.concatMapStringsSep " " (path: "-I ${lib.escapeShellArg path}") qmlImportPaths;
  qmllsWrapped = pkgs.writeShellScriptBin "qmlls-wrapped" ''
    exec ${pkgs.qt6.qtdeclarative}/bin/qmlls ${qmlImportArgs} "$@"
  '';
  doomBootstrap = pkgs.writeShellScriptBin "doom-bootstrap" ''
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
  '';
  doomEmacs = pkgs.writeShellScriptBin "doom-emacs" ''
    if ! ${pkgs.emacs-pgtk}/bin/emacsclient --eval t >/dev/null 2>&1; then
      ${pkgs.systemd}/bin/systemctl --user start emacs.service >/dev/null 2>&1 || true
    fi

    exec ${pkgs.emacs-pgtk}/bin/emacsclient --create-frame --alternate-editor=${lib.escapeShellArg "${pkgs.emacs-pgtk}/bin/emacs"} "$@"
  '';
  doomEmacsTerminal = pkgs.writeShellScriptBin "doom-emacs-terminal" ''
    if ! ${pkgs.emacs-pgtk}/bin/emacsclient --eval t >/dev/null 2>&1; then
      ${pkgs.systemd}/bin/systemctl --user start emacs.service >/dev/null 2>&1 || true
    fi

    exec ${pkgs.emacs-pgtk}/bin/emacsclient --tty --alternate-editor=${lib.escapeShellArg "${pkgs.emacs-pgtk}/bin/emacs"} "$@"
  '';
  emacsRuntimePackages = with pkgs; [
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
    qmllsWrapped

    # Nix editing support for the Emacs experiment.
    nil
    nixfmt

    doomBootstrap
    doomEmacs
    doomEmacsTerminal
  ];
  emacsRuntimePath =
    "/etc/profiles/per-user/${config.home.username}/bin:" + lib.makeBinPath emacsRuntimePackages;
in
{
  home.packages = emacsRuntimePackages;

  home.sessionPath = [
    "${emacsDir}/bin"
  ];

  home.sessionVariables = {
    DOOMDIR = doomDir;
  };

  xdg.desktopEntries.emacs = {
    name = "Emacs";
    genericName = "Text Editor";
    comment = "Edit text with the Doom Emacs daemon";
    exec = "doom-emacs %F";
    icon = "emacs";
    terminal = false;
    categories = [
      "Development"
      "TextEditor"
      "Utility"
    ];
    mimeType = [
      "text/plain"
      "text/markdown"
      "text/org"
    ];
  };

  systemd.user.services.emacs = {
    Unit = {
      Description = "Emacs daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Environment = [
        "DOOMDIR=${doomDir}"
        "PATH=${emacsRuntimePath}"
      ];
      ExecStart = "${pkgs.emacs-pgtk}/bin/emacs --fg-daemon";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}

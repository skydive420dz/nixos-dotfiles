{
  config,
  lib,
  pkgs,
  ...
}:

let
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
  emacsRuntimeTools = with pkgs; [
    emacs-pgtk

    # Shell/build tools used by Emacs packages with native modules.
    bashInteractive
    coreutils
    findutils
    perl
    cmake
    gnumake
    gcc
    libtool
    autoconf
    automake
    pkg-config

    # Core editor/project tooling.
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

    # Language server support.
    nodejs
    typescript
    typescript-language-server
    prettier
    html-tidy
    stylelint
    jsbeautifier
    lua
    lua-language-server
    stylua
    basedpyright
    pipenv
    black
    isort
    ruff
    python3Packages.pyflakes
    python3Packages.pytest
    haskell-language-server
    ghc
    cabal-install
    haskellPackages.hoogle
    vscode-langservers-extracted
    yaml-language-server
    bash-language-server
    marksman
    qt6.qtlanguageserver
    rust-analyzer
    rustc
    cargo
    rustfmt
    clang-tools
    shellcheck
    shfmt
    glslang
    glsl_analyzer
    qmllsWrapped

    # Nix editing support.
    nil
    nixfmt
  ];
  emacsRuntimePath =
    "/run/current-system/sw/bin:/etc/profiles/per-user/${config.home.username}/bin:"
    + lib.makeBinPath emacsRuntimeTools;
  emacsSync = pkgs.writeShellScriptBin "emacs-sync" ''
    set -euo pipefail

    export PATH="${emacsRuntimePath}:''${PATH-}"

    ${pkgs.emacs-pgtk}/bin/emacs --batch \
      -l "$HOME/.config/emacs/early-init.el" \
      -l "$HOME/.config/emacs/init.el" \
      --eval "(message \"emacs packages loaded\")"

    vterm_dir="$(
      find "$HOME/.cache/emacs/elpa" \
        -maxdepth 1 \
        -type d \
        -name 'vterm-*' \
      | sort \
      | tail -n 1
    )"

    if [ -z "$vterm_dir" ]; then
      echo "emacs-sync: vterm package directory not found" >&2
      exit 1
    fi

    cmake -S "$vterm_dir" -B "$vterm_dir/build" -DUSE_SYSTEM_LIBVTERM=Off
    cmake --build "$vterm_dir/build"
    test -f "$vterm_dir/vterm-module.so"

    ${pkgs.emacs-pgtk}/bin/emacs --batch \
      -l "$HOME/.config/emacs/early-init.el" \
      -l "$HOME/.config/emacs/init.el" \
      --eval "(progn (require 'vterm) (message \"emacs-sync complete\"))"
  '';
in
{
  home.packages = emacsRuntimeTools ++ [
    emacsSync
  ];

  xdg.desktopEntries.emacs = {
    name = "Emacs";
    genericName = "Text Editor";
    comment = "Edit text with Emacs";
    exec = "emacsclient --create-frame --alternate-editor=emacs %F";
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
        "PATH=${emacsRuntimePath}"
      ];
      ExecStart = "${pkgs.emacs-pgtk}/bin/emacs --fg-daemon";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}

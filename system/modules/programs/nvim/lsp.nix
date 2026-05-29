{ pkgs, lib, ... }:
let
  qmlImportPaths = [
    "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    "${pkgs.quickshell}/lib/qt-6/qml"
  ];
  qmlImportArgs = lib.concatMapStringsSep " " (path: "-I ${path}") qmlImportPaths;
in
{
  programs.nvf.settings.vim.lsp = {
    enable = true;
    formatOnSave = false;
    lspkind.enable = false;
    lightbulb.enable = true;
    lspsaga.enable = false;
    trouble.enable = false;
    lspSignature.enable = false;
    presets.harper.enable = true;
    servers.qmlls = {
      cmd = lib.mkForce [
        "${pkgs.writeShellScriptBin "qmlls-wrapped" ''
          extra_imports=()
          [ -d "$HOME/.config/quickshell" ] && extra_imports+=(-I "$HOME/.config/quickshell")
          [ -d "$PWD/config/quickshell" ] && extra_imports+=(-I "$PWD/config/quickshell")

          exec ${pkgs.qt6.qtdeclarative}/bin/qmlls ${qmlImportArgs} "''${extra_imports[@]}" "$@"
        ''}/bin/qmlls-wrapped"
      ];
    };
  };
}

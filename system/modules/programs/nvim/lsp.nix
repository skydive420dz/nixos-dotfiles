{
  pkgs,
  lib,
  repoPath,
  ...
}:
let
  quickshellConfigSource = ../../../../config/quickshell;
  qmlImportPaths = [
    "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
    "${quickshellConfigSource}"
    "${repoPath}/config/quickshell"
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    "${pkgs.quickshell}/lib/qt-6/qml"
  ];
  qmlImportArgs = lib.concatMapStringsSep " " (path: "-I ${lib.escapeShellArg path}") qmlImportPaths;
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
          exec ${pkgs.qt6.qtdeclarative}/bin/qmlls ${qmlImportArgs} "$@"
        ''}/bin/qmlls-wrapped"
      ];
    };
  };
}

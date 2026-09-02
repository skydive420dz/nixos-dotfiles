{
  config,
  hostname,
  inputs,
  lib,
  pkgs,
  repoPath,
  ...
}:

let
  extensionIds = [
    "eamodio.gitlens"
    "jnoortheen.nix-ide"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-vscode.cmake-tools"
    "ms-vscode.cpptools"
    "ms-vscode.cpptools-extension-pack"
    "vscode-icons-team.vscode-icons"
    "vscodevim.vim"
    "bbenoist.qml"
    "davidanson.vscode-markdownlint"
    "editorconfig.editorconfig"
    "evzen-wybitul.magic-racket"
    "fireblast.hyprlang-vscode"
    "github.copilot-chat"
    "mads-hartmann.bash-ide-vscode"
    "malmaud.tmux"
    "ms-python.vscode-python-envs"
    "ms-vscode.cpp-devtools"
    "ms-vscode.cpptools-themes"
    "ms-vscode.powershell"
    "openai.chatgpt"
    "qingpeng.common-lisp"
    "rszyma.vscode-kanata"
    "sjhuangx.vscode-scheme"
    "sumneko.lua"
    "theqtcompany.qt-core"
    "theqtcompany.qt-qml"
    "tootone.org-mode"
  ];

  vscodeInstallExtensions = pkgs.writeShellApplication {
    name = "vscode-install-extensions";
    runtimeInputs = [ pkgs.vscode ];
    text = ''
      unset VSCODE_IPC_HOOK_CLI

      for extension in ${lib.escapeShellArgs extensionIds}; do
        code --extensions-dir "$HOME/.vscode/extensions" --install-extension "$extension"
      done

      code --extensions-dir "$HOME/.vscode/extensions" \
        --install-extension ms-vscode.vscode-chat-customizations-evaluations --pre-release
    '';
  };
in
{
  config = lib.mkIf (hostname == "nixos") {
    home = {
      packages = [
        pkgs.codex
        vscodeInstallExtensions
      ];

      file.".agents/skills/ponytail".source = "${inputs.ponytail}/skills/ponytail";
      file.".vscode-server/data/Machine/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/vscode/remote-settings.json";
    };

    xdg.configFile."Code/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/vscode/settings.json";

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      mutableExtensionsDir = true;
    };
  };
}

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
  release = builtins.fromJSON (builtins.readFile ../../../config/vscode/release.json);
  vscode = import ../../../config/vscode/package.nix { inherit pkgs release; };
  agentHostCli = pkgs.callPackage ../../../config/vscode/agent-host-cli.nix {
    inherit vscode release;
  };

  vscodeInstallExtensions = pkgs.writeShellApplication {
    name = "vscode-install-extensions";
    runtimeInputs = [
      pkgs.python3
      vscode
    ];
    text = ''
      exec python3 ${../../../config/vscode/extensions.py} "$@" \
        --manifest ${../../../config/vscode/release.json}
    '';
  };

  vscodeMsi = pkgs.writeShellApplication {
    name = "code-msi";
    text = ''
      unset VSCODE_IPC_HOOK_CLI
      exec ${vscode}/bin/code --remote ssh-remote+msi "$@"
    '';
  };
in
{
  config = lib.mkIf (hostname == "nixos") {
    home = {
      packages = [
        pkgs.codex
        vscodeInstallExtensions
        vscodeMsi
        agentHostCli
      ];

      file.".agents/skills/ponytail".source = "${inputs.ponytail}/skills/ponytail";
      file.".vscode-server/data/Machine/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/vscode/remote-settings.json";
    };

    xdg.configFile."Code/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/vscode/settings.json";

    xdg.desktopEntries.code = {
      name = "Visual Studio Code";
      genericName = "Text Editor";
      comment = "Edit projects on MSI over SSH";
      exec = "${vscodeMsi}/bin/code-msi %F";
      icon = "vscode";
      startupNotify = true;
      categories = [
        "Utility"
        "TextEditor"
        "Development"
        "IDE"
      ];
      mimeType = [
        "application/x-code-workspace"
        "text/plain"
        "inode/directory"
      ];
      settings.StartupWMClass = "Code";
      actions.new-empty-window = {
        name = "New Window";
        exec = "${vscodeMsi}/bin/code-msi --new-window";
      };
    };

    programs.vscode = {
      enable = true;
      package = vscode;
      mutableExtensionsDir = true;
    };
  };
}

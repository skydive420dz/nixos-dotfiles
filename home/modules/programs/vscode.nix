{
  hostname,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  marketplace =
    inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace-release;

  marketplacePreRelease =
    inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
in
{
  config = lib.mkIf (hostname == "nixos") {
    home = {
      packages = [ pkgs.codex ];

      file.".agents/skills/ponytail".source = "${inputs.ponytail}/skills/ponytail";
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      mutableExtensionsDir = true;

      profiles.default = {
        userSettings = {
          "workbench.colorTheme" = "Dark+";
          "chat.mcp.gallery.enabled" = true;
          "workbench.iconTheme" = "vscode-icons";
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "window.restoreWindows" = "preserve";
          "window.openFoldersInNewWindow" = "on";
        };

        extensions = with pkgs.vscode-extensions; [
          eamodio.gitlens
          jnoortheen.nix-ide
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-pylance
          ms-vscode.cmake-tools
          ms-vscode.cpptools
          ms-vscode.cpptools-extension-pack
          vscode-icons-team.vscode-icons
          vscodevim.vim
          marketplace.bbenoist.qml
          marketplace.davidanson.vscode-markdownlint
          marketplace.editorconfig.editorconfig
          marketplace.evzen-wybitul.magic-racket
          marketplace.fireblast.hyprlang-vscode
          marketplace.github.copilot-chat
          marketplace.mads-hartmann.bash-ide-vscode
          marketplace.malmaud.tmux
          marketplace.ms-python.vscode-python-envs
          marketplace.ms-vscode.cpp-devtools
          marketplace.ms-vscode.cpptools-themes
          marketplace.ms-vscode.powershell
          marketplace.openai.chatgpt
          marketplace.qingpeng.common-lisp
          marketplace.rszyma.vscode-kanata
          marketplace.sjhuangx.vscode-scheme
          marketplace.sumneko.lua
          marketplace.theqtcompany.qt-core
          marketplace.theqtcompany.qt-qml
          marketplace.tootone.org-mode
          marketplacePreRelease.ms-vscode.vscode-chat-customizations-evaluations
        ];
      };
    };
  };
}

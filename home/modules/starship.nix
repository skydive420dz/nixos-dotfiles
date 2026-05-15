# ============================================
# STARSHIP PROMPT
# ============================================
# Calm prompt in Catppuccin Mocha:
#
#   [ ~/dir ]  branch status
#   ❯
#
# Git info appears as an extra pill after the directory only when in a repo.
#
# Requires a Nerd Font (JetBrainsMono Nerd Font is set system-wide).

{ lib, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;

      format = lib.concatStrings [
        # ── Directory + git ───────────────────────────────────────────────
        "$directory"
        "$git_branch"
        "$git_status"

        # ── Newline before prompt character ───────────────────────────────
        "\n"
        "$character"
      ];

      os = {
        disabled = false;
        style = "fg:#a6e3a1";
        symbols = {
          NixOS = " ";
          Macos = " ";
          Ubuntu = " ";
          Arch = "󰣇 ";
          Debian = " ";
          Fedora = " ";
          Linux = " ";
        };
        format = "[$symbol]($style)";
      };

      shell = {
        disabled = false;
        style = "fg:#6c7086";
        bash_indicator = " bash";
        zsh_indicator = " zsh";
        fish_indicator = "󰈺 fish";
        unknown_indicator = " sh";
        format = "[$indicator ]($style)";
      };

      username = {
        show_always = true;
        style_user = "fg:#6c7086";
        style_root = "fg:#f38ba8 bold";
        format = "[ $user ]($style)";
      };

      hostname = {
        ssh_only = true;
        style = "fg:#6c7086";
        format = "[@$hostname ]($style)";
      };

      directory = {
        style = "fg:#cdd6f4 bg:#313244";
        format = "[ $path ]($style)[ ](fg:#6c7086)";
        truncation_length = 3;
        truncation_symbol = "…/";
        home_symbol = " ~";
        substitutions = {
          "Documents" = "󰈙";
          "Downloads" = "";
          "Music" = "󰝚";
          "Pictures" = "";
          "Videos" = "󰕧";
          "nixos-dotfiles" = "";
        };
      };

      git_branch = {
        symbol = "";
        style = "fg:#b4befe";
        format = "[󰊢 $branch ]($style)";
      };

      git_status = {
        style = "fg:#6c7086";
        format = "[$all_status$ahead_behind]($style)";
        conflicted = "󰞇 ";
        ahead = "󱓊 \${count}";
        behind = "󱓋 \${count}";
        diverged = "󰜘 \${ahead_count} 󰜙 \${behind_count}";
        up_to_date = "󱓏 ";
        untracked = "󰋖 ";
        stashed = "󰉓 ";
        modified = "󰷈 ";
        staged = "󰐗 ";
        renamed = "󰑕 ";
        deleted = "󰗨 ";
      };

      character = {
        success_symbol = "[❯](bold fg:#a6e3a1)";
        error_symbol = "[❯](bold fg:#f38ba8)";
        vimcmd_symbol = "[❮](bold fg:#cba6f7)";
      };
    };
  };
}

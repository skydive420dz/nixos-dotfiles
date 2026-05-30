# ============================================
# STARSHIP PROMPT
# ============================================
# Calm prompt using the global Sky theme fallback:
#
#   [ ~/dir ]  branch status
#   ❯
#
# Git info appears as an extra pill after the directory only when in a repo.
#
# Requires a Nerd Font (JetBrainsMono Nerd Font is set system-wide).

{ lib, ... }:

let
  theme = import ../../../theme/tokens.nix;
  s = theme.semantic;
in
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
        style = "fg:${s.success}";
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
        style = "fg:${s.muted}";
        bash_indicator = " bash";
        zsh_indicator = " zsh";
        fish_indicator = "󰈺 fish";
        unknown_indicator = " sh";
        format = "[$indicator ]($style)";
      };

      username = {
        show_always = true;
        style_user = "fg:${s.muted}";
        style_root = "fg:${s.danger} bold";
        format = "[ $user ]($style)";
      };

      hostname = {
        ssh_only = true;
        style = "fg:${s.muted}";
        format = "[@$hostname ]($style)";
      };

      directory = {
        style = "fg:${s.foreground} bg:${s.surfaceStrong}";
        format = "[ $path ]($style)[ ](fg:${s.muted})";
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
        style = "fg:${s.accent}";
        format = "[󰊢 $branch ]($style)";
      };

      git_status = {
        style = "fg:${s.muted}";
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
        success_symbol = "[❯](bold fg:${s.success})";
        error_symbol = "[❯](bold fg:${s.danger})";
        vimcmd_symbol = "[❮](bold fg:${s.accentAlt})";
      };
    };
  };
}

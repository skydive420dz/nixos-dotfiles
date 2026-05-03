# ============================================
# STARSHIP PROMPT
# ============================================
# Multi-pill prompt inspired by NetworkChuck's setup, in Catppuccin Mocha:
#
#   [ ❄ NixOS ][  zsh ][  user@host ]
#   [ 󰋜 ~/dir ]
#   ❯
#
# Pills (left → right, top row):
#   1. OS      — NixOS snowflake on Catppuccin green
#   2. Shell   — current shell on darker surface
#   3. User    — user@hostname on Catppuccin yellow/peach
# Second row:
#   4. Dir     — current directory on Catppuccin blue
# Third row:
#   5. Char    — prompt character (❯) green/red on success/fail
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
        # ── Top row: os | shell | user@host ───────────────────────────────
        "[](#a6e3a1)"
        "$os"
        "[](bg:#313244 fg:#a6e3a1)"
        "$shell"
        "[](bg:#fab387 fg:#313244)"
        "$username"
        "$hostname"
        "[](fg:#fab387)"

        # ── Newline before directory pill ─────────────────────────────────
        "\n"

        # ── Second row: directory + git ───────────────────────────────────
        "[](#89b4fa)"
        "$directory"
        "[](fg:#89b4fa bg:#cba6f7)"
        "$git_branch"
        "$git_status"
        "[](fg:#cba6f7)"

        # ── Newline before prompt character ───────────────────────────────
        "\n"
        "$character"
      ];

      os = {
        disabled = false;
        style = "bg:#a6e3a1 fg:#1e1e2e";
        symbols = {
          NixOS = "󰜗 NixOS";
          Macos = " macOS";
          Ubuntu = " Ubuntu";
          Arch = " Arch";
          Debian = " Debian";
          Fedora = " Fedora";
          Linux = " Linux";
        };
        format = "[ $symbol ]($style)";
      };

      shell = {
        disabled = false;
        style = "bg:#313244 fg:#cdd6f4";
        bash_indicator = " bash";
        zsh_indicator = " zsh";
        fish_indicator = "󰈺 fish";
        unknown_indicator = " sh";
        format = "[ $indicator ]($style)";
      };

      username = {
        show_always = true;
        style_user = "bg:#fab387 fg:#1e1e2e";
        style_root = "bg:#f38ba8 fg:#1e1e2e";
        format = "[  $user]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "bg:#fab387 fg:#1e1e2e";
        format = "[@$hostname ]($style)";
      };

      directory = {
        style = "fg:#1e1e2e bg:#89b4fa";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        home_symbol = "󰋜 ~";
        substitutions = {
          "/" = " 󰉋 /";
          "Documents" = " 󰈙 ";
          "Downloads" = " 󰛀 ";
          "Music" = " 󰝚 ";
          "Pictures" = "  ";
          "Videos" = " 󰕧 ";
          "nixos-dotfiles" = " dotfiles";
        };
      };

      git_branch = {
        symbol = " ";
        style = "bg:#cba6f7 fg:#1e1e2e";
        format = "[ $symbol$branch ]($style)";
      };

      git_status = {
        style = "bg:#cba6f7 fg:#1e1e2e";
        format = "[ $all_status$ahead_behind]($style)";
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
        success_symbol = "[ ❯](bold fg:#a6e3a1)";
        error_symbol = "[ ❯](bold fg:#f38ba8)";
        vimcmd_symbol = "[ ❮](bold fg:#cba6f7)";
      };
    };
  };
}

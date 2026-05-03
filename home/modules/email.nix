# ============================================
# EMAIL — aerc (TUI mail client) [home-manager]
# ============================================
# Stack:
#   aerc           — the mail client itself (TUI, multi-account)
#   w3m            — render HTML email as text
#   gnupg          — encrypted credentials in accounts.conf via gpg
#   pass           — password store (used by source-cred-cmd / outgoing-cred-cmd)
#   notmuch        — fast indexed search across all accounts
#   abook          — contact management
#   pinentry-curses — TUI passphrase prompt for gpg
#
# Configuration files live in ~/.config/aerc/ (managed via the dotfiles
# symlinks — see home/modules/links.nix).

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    aerc
    w3m
    gnupg
    pass
    notmuch
    abook
  ];
}

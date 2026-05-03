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
    pinentry-curses # ensure a TUI pinentry exists for gpg-agent
  ];

  # gpg-agent under home-manager. Uses curses pinentry so passphrase
  # prompts stay inside the terminal — no GUI popups required.
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    enableSshSupport = false;
    defaultCacheTtl = 7200; # 2 hours — type passphrase once per session
    maxCacheTtl = 28800; # 8 hours absolute max
  };
}

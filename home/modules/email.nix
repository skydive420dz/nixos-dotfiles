# ============================================
# EMAIL — aerc (TUI mail client)
# ============================================
# Stack:
#   aerc           — the mail client itself (TUI, multi-account)
#   w3m            — render HTML email as text
#   dante          — SOCKS proxy support (rare; pulled by some aerc filters)
#   gnupg          — encrypted credentials in accounts.conf via gpg
#   pass           — password store (used by source-cred-cmd / outgoing-cred-cmd)
#   notmuch        — fast indexed search across all accounts
#
# Configuration files (NOT managed here — live in ~/.config/aerc/):
#   accounts.conf  — per-account IMAP/SMTP settings
#   aerc.conf      — UI, behavior, viewer
#   binds.conf     — keybindings
#
# Templates for those files are in this dotfiles repo under config/aerc/.

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aerc
    w3m # HTML rendering
    dante # used by some filters
    gnupg # encrypted secrets
    pass # password manager (recommended for credentials)
    notmuch # indexed search
    # Optional but useful:
    abook # contact management
    msmtp # alternative SMTP sender (not needed for aerc itself)
  ];

  # Make notmuch work with aerc out of the box.
  # The actual notmuch DB config lives in ~/.notmuch-config and is created
  # the first time you run `notmuch new` after setting up your maildir.
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses; # TUI pinentry, no GUI popups
  };
}

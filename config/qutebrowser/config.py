# ============================================
# QUTEBROWSER CONFIGURATION
# ============================================
# Style: keyboard-first with mouse fallback.
# Theme: loaded from the global Sky theme selector.
# Reload in-app with :config-source — no restart required.

import os
import runpy
from pathlib import Path

config.load_autoconfig()

# ── Theme ──────────────────────────────────────────────────────────────────
config_home = Path(os.environ.get("XDG_CONFIG_HOME", str(Path.home() / ".config")))
theme_data = {}

for theme_file in [
    config_home / "theme/current/qutebrowser.py",
    config_home / "qutebrowser/sky_theme_fallback.py",
]:
    if theme_file.exists():
        theme_data = runpy.run_path(str(theme_file))
        theme_data["setup"](c)
        break

theme_flavor = theme_data.get("FLAVOR", "dark")

# Force dark mode on websites that don't have their own dark theme.
# Images are kept at original colors so photos and icons don't get inverted.
c.colors.webpage.darkmode.enabled = theme_flavor != "light"
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.darkmode.policy.page = "smart"
c.colors.webpage.preferred_color_scheme = theme_flavor

# ── Fonts ──────────────────────────────────────────────────────────────────
# Tweak default_family if you have a preferred sans (e.g. "JetBrainsMono Nerd Font").
c.fonts.default_family = []
c.fonts.default_size = "11pt"
c.fonts.web.family.standard = "Inter"
c.fonts.web.family.serif = "Source Serif Pro"
c.fonts.web.family.sans_serif = "Inter"
c.fonts.web.family.fixed = "JetBrainsMono Nerd Font"
c.fonts.web.size.default = 16
c.fonts.web.size.default_fixed = 14

# ── UI behavior ────────────────────────────────────────────────────────────
# Tab bar
c.tabs.position = "top"
c.tabs.title.format = "{audio}{index}: {current_title}"
c.tabs.title.format_pinned = "{audio}{current_title}"
c.tabs.last_close = "close"
c.tabs.show = "multiple"  # hide tab bar when only one tab open
c.tabs.background = True  # open new tabs in background by default
c.tabs.new_position.unrelated = "next"  # open new tabs next to current, not at end
c.tabs.new_position.related = "next"
c.tabs.mousewheel_switching = False  # don't switch tabs when scrolling on tab bar

# Status bar
c.statusbar.show = (
    "in-mode"  # only show statusbar in command/insert mode (cleaner look)
)

# Scrolling
c.scrolling.smooth = True
c.scrolling.bar = "when-searching"

# Window
c.window.title_format = "{audio}{current_title}{title_sep}qutebrowser"
c.window.transparent = True  # honored by Hyprland's opacity rules

# ── Search engines ─────────────────────────────────────────────────────────
# Use as: `:open SEARCHTERMS` for default, `:open !KEY TERMS` for others.
# Example: `:open !gh hyprland` searches GitHub.
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "g": "https://www.google.com/search?q={}",
    "gh": "https://github.com/search?q={}&type=repositories",
    "nw": "https://search.nixos.org/packages?query={}",
    "nx": "https://search.nixos.org/options?query={}",
    "no": "https://noogle.dev/q?term={}",
    "hw": "https://wiki.hyprland.org/?search={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "w": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "r": "https://reddit.com/r/{}",
    "mdn": "https://developer.mozilla.org/en-US/search?q={}",
    "so": "https://stackoverflow.com/search?q={}",
}

# ── Default page and downloads ─────────────────────────────────────────────
c.url.default_page = "about:blank"
c.url.start_pages = ["about:blank"]

c.downloads.location.directory = "~/Downloads"
c.downloads.location.prompt = False
c.downloads.position = "bottom"
c.downloads.remove_finished = 5000  # auto-clear finished downloads after 5s

# ── Privacy & content ──────────────────────────────────────────────────────
c.content.cookies.accept = "no-3rdparty"
c.content.geolocation = "ask"
c.content.notifications.enabled = "ask"
c.content.autoplay = False
c.content.blocking.method = "both"  # uses adblock + brave-style host blocking
c.content.blocking.adblock.lists = [
    # Already in your config:
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://easylist.to/easylist/fanboy-annoyance.txt",
    # Strong additions:
    "https://easylist.to/easylist/fanboy-social.txt",  # Social widgets
    "https://easylist-downloads.adblockplus.org/easylist_noelemhide.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt",
    # Annoyances (cookie banners, newsletter popups, etc.):
    "https://www.i-dont-care-about-cookies.eu/abp/",
    # YouTube ads / sponsorblock-style:
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
]
c.content.headers.do_not_track = True

# Hardware accel — works fine on AMD/NVIDIA in your setup
c.qt.chromium.process_model = "process-per-site-instance"

# Spell checking
c.spellcheck.languages = ["en-US"]

# ── Hints (the link-jumping feature) ───────────────────────────────────────
# Default keybinds are home-row, which is good. Tweaks below.
c.hints.chars = "asdfghjkl;"  # home row
c.hints.uppercase = False
c.hints.scatter = False  # sequential hint chars (easier to predict)

# ── Editor for external editing (Ctrl+E in text fields) ────────────────────
c.editor.command = ["kitty", "--class", "qute-editor", "-e", "nvim", "{file}"]

# ── Keybindings ────────────────────────────────────────────────────────────
# qutebrowser already has great defaults (vim-style). These are additions
# and overrides for common workflows.

# Reload config without restarting
config.bind(",r", "config-source")

# Adblock keys
config.bind(",b", "config-cycle content.blocking.enabled true false")
config.bind(",B", "adblock-update")
# Tab management
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("<Ctrl-Shift-t>", "undo")  # restore closed tab (Ctrl+Shift+T like Firefox)
config.bind("<Ctrl-t>", "open -t")  # new tab with prompt
config.bind("<Ctrl-w>", "tab-close")  # close tab

# Quick search engine binds (open in new tab)
config.bind(",g", "set-cmd-text -s :open -t !g")
config.bind(",y", "set-cmd-text -s :open -t !yt")
config.bind(",h", "set-cmd-text -s :open -t !gh")
config.bind(",n", "set-cmd-text -s :open -t !nw")

# Common Firefox-style binds for mouse-fallback users
config.bind("<Ctrl-l>", "cmd-set-text -s :open")  # like Firefox address bar focus

# YouTube / video in mpv
config.bind(",m", "spawn mpv {url}")
config.bind(",M", "hint links spawn mpv {hint-url}")

# Toggle dark mode on the fly
config.bind(",d", "config-cycle colors.webpage.darkmode.enabled true false")

# Toggle stylesheet (useful for sites with broken dark mode)
config.bind(
    ",s",
    "config-cycle content.user_stylesheets ~/.config/qutebrowser/userstyles.css ''",
)

# Mute / unmute current tab
config.bind(",a", "tab-mute")

# Copy URL / title
config.bind(",cu", "yank")
config.bind(",ct", "yank title")

# Quick quit (with confirmation prompt for safety on accidental quits)
config.bind("<Ctrl-q>", "quit --save")

# Mouse: middle-click on link opens in background tab (already default, here for reference)
# config.bind("<button-middle>", "hint links tab-bg", mode="normal")

# ── Per-domain content settings ────────────────────────────────────────────
# Block JS by default? No — too disruptive. Whitelist if you want.
# Here are some site-specific tweaks instead:

# Allow autoplay on video sites you trust
for site in ["https://www.youtube.com", "https://twitch.tv", "https://www.twitch.tv"]:
    config.set("content.autoplay", True, site + "/*")

# Allow notifications for messaging apps
for site in [
    "https://discord.com",
    "https://web.telegram.org",
    "https://app.element.io",
]:
    config.set("content.notifications.enabled", True, site + "/*")

# Allow geolocation for maps
config.set("content.geolocation", True, "https://*.google.com/maps/*")
config.set("content.geolocation", True, "https://www.openstreetmap.org/*")

# ── Quality of life ────────────────────────────────────────────────────────
c.completion.height = "30%"
c.completion.scrollbar.width = 8
c.completion.show = "always"
c.completion.use_best_match = True

c.session.lazy_restore = True  # restore tabs on demand, faster startup

# Prevent prompt dialogs from blocking the UI
c.prompt.filebrowser = True

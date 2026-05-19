# ============================================
# FIREFOX (fallback browser)
# ============================================
# Lean Firefox config — qutebrowser is primary, this is fallback for
# sites qutebrowser breaks on or videos that need full media stack.
#
# Extensions managed declaratively via NUR (firefox-addons input).
# AdNauseam is NOT here — it's installed manually from getadnauseam.com
# (Mozilla doesn't allow it on AMO, so it's not in NUR either).
# Manual extensions coexist fine with the declarative ones.
#
# Lives in home/modules/programs/firefox.nix.

{ pkgs, inputs, ... }:

let
  # Pick the addon set for the current system. NUR's firefox-addons flake
  # exposes a packages set per system.
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox"; # ← add this line
    nativeMessagingHosts = with pkgs; [ browserpass ]; # ← new line
    profiles.default = {
      isDefault = true;

      # ── Extensions (declarative via NUR) ──────────────────────────────
      # AdNauseam stays manually installed — they coexist.
      extensions.packages = with addons; [
        ublock-origin # ad/tracker blocker (gold standard)
        sponsorblock # skip YouTube sponsor segments
        clearurls # strip tracking params from URLs
        istilldontcareaboutcookies # auto-dismiss cookie banners
        darkreader # dark mode for any site
        browserpass # integrates with `pass` for credentials
      ];

      # ── about:config tweaks ───────────────────────────────────────────
      settings = {
        # ── Telemetry / data collection (off) ───────────────────────────
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.ping-centre.telemetry" = false;

        # ── Pocket and "recommendations" cruft (off) ────────────────────
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;

        # ── Privacy ──────────────────────────────────────────────────────
        "browser.contentblocking.category" = "strict";
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        "network.http.referer.XOriginPolicy" = 2;
        "network.http.referer.XOriginTrimmingPolicy" = 2;

        # ── GPU / rendering (snappier) ──────────────────────────────────
        # WebRender — Firefox's GPU compositor. Big win on scroll/video.
        "gfx.webrender.all" = true;
        # Hardware video decode (NVIDIA via VAAPI works in Wayland sessions)
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        # Native Wayland buffers (avoids xwayland fallback)
        "widget.dmabuf.force-enabled" = true;
        # Use Firefox's internal theme for form widgets (faster than GTK)
        "widget.non-native-theme.enabled" = true;

        # ── Layout / paint performance ──────────────────────────────────
        # More concurrent connections per host (faster page loads)
        "network.http.max-persistent-connections-per-server" = 10;
        # RAM cache (your laptop has it; skip SSD writes for cache)
        "browser.cache.memory.capacity" = 1048576;
        "browser.cache.disk.enable" = false;
        # Foreground-tab process priority
        "dom.ipc.processPriorityManager.enabled" = true;

        # ── Animation / scroll feel ─────────────────────────────────────
        # Instant fullscreen toggle
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.timeout" = 0;
        # No "you have N tabs" warning on close
        "browser.tabs.warnOnClose" = false;
        "browser.tabs.warnOnCloseOtherTabs" = false;

        # ── UX cleanup ──────────────────────────────────────────────────
        "browser.startup.homepage" = "about:blank";
        "browser.startup.page" = 3; # 3 = restore previous session
        "browser.newtabpage.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.aboutConfig.showWarning" = false;
        "browser.urlbar.suggest.engines" = false; # no search engine ads
        "browser.urlbar.suggest.openpage" = true; # but show open tabs
        "browser.urlbar.trimURLs" = false; # show full URL incl https://

        # ── Search ──────────────────────────────────────────────────────
        "browser.search.suggest.enabled" = false; # no live suggestions
        "keyword.enabled" = true; # !bang-style keywords

        # ── Safety nets you probably want ───────────────────────────────
        "browser.sessionstore.warnOnQuit" = true;
        "signon.rememberSignons" = false; # use pass + browserpass
      };
    };
  };
}

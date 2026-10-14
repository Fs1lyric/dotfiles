// Turn on custom CSS (userChrome.css / userContent.css)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Ctrl+T / "+" opens a real new tab page instead of the floating search bar, with the shortcuts row hidden
user_pref("zen.urlbar.replace-newtab", false);
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Translucent glass: Zen draws its own see-through surfaces (Hyprland blurs behind them),
// so the window stays fully opaque and videos are never see-through.
user_pref("zen.widget.linux.transparency", true);
user_pref("browser.tabs.allow_transparent_browser", true);

// Hardware video decoding through VA-API (AMD Radeon, Mesa radeonsi) so video doesn't run on the CPU
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("media.ffmpeg.vaapi.enabled", true);

// Keep the new tab page clean: no stories, no sponsored content
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);

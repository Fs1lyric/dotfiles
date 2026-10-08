// Turn on custom CSS (userChrome.css / userContent.css)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Ctrl+T / "+" opens a real new tab page (shortcuts, pinned sites) instead of the floating search bar
user_pref("zen.urlbar.replace-newtab", false);
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", true);

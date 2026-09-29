// ==========================================================================
//  user.js — applied on every Firefox start, overriding prefs.js.
//  Previous version: user.js.bak-20260925-114452
// ==========================================================================

// --------------------------------------------------------------------------
//  Kept from the previous user.js
// --------------------------------------------------------------------------

// Enable SVG context colors in UI
user_pref("svg.context-properties.content.enabled", true);

// Restore tabs and windows on restart
user_pref("browser.startup.page", 3);

// Monospace font preference
user_pref("font.name.monospace.x-western", "JetBrainsMono Nerd Font");

// Disable IPv6 in Firefox since the network only has IPv4 default route
user_pref("network.dns.disableIPv6", true);

// --------------------------------------------------------------------------
//  Zen-style setup (all prefs below exist in Firefox 154)
// --------------------------------------------------------------------------

// Load chrome/userChrome.css and chrome/userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Native vertical tabs in the new sidebar, collapsed until hovered
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", true);
user_pref("sidebar.visibility", "expand-on-hover");

// Compact mode, and offer it in Customize Toolbar > Density
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 1);

// Tab groups, with a preview of a group's tabs on hover
user_pref("browser.tabs.groups.enabled", true);
user_pref("browser.tabs.groups.hoverPreview.enabled", true);

// Tab hover previews with page thumbnails
user_pref("browser.tabs.hoverPreview.enabled", true);
user_pref("browser.tabs.hoverPreview.showThumbnails", true);

// Split view: two tabs side by side
user_pref("browser.tabs.splitView.enabled", true);

// Glance-style Link Preview: long-press a link, or hover it holding
// Shift+Alt, for a preview card of the page
user_pref("browser.ml.linkPreview.enabled", true);
user_pref("browser.ml.linkPreview.longPress", true);
user_pref("browser.ml.linkPreview.shiftAlt", true);

// Hide the bookmarks toolbar (Ctrl+Shift+B still shows it; it is hidden
// again on the next start)
user_pref("browser.toolbars.bookmarks.visibility", "never");

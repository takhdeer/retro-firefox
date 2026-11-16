#!/bin/bash
# Launch a separate Firefox test window that loads the theme straight from this repo.
# Runs alongside your normal Firefox without touching it.
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"
PROFILE="$REPO/.test-profile"
FIREFOX="/Applications/Firefox.app/Contents/MacOS/firefox"

mkdir -p "$PROFILE"

# Copy the theme into the test profile. It must be a real copy, not a symlink:
# Firefox's macOS sandbox blocks web/new-tab pages from reading userContent.css
# through a symlink that points outside the profile.
rm -rf "$PROFILE/chrome"
cp -R "$REPO/chrome" "$PROFILE/chrome"

cat > "$PROFILE/user.js" <<'PREFS'
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);
user_pref("devtools.debugger.prompt-connection", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("trailhead.firstrun.didSeeAboutWelcome", true);
PREFS

"$FIREFOX" -no-remote -profile "$PROFILE" >/dev/null 2>&1 &
echo "Test window launched (profile: $PROFILE)"

#!/bin/bash
# Copy the theme into your main Firefox profile. Restart Firefox afterwards.
# (A real copy is required: a symlinked chrome folder stops userContent.css from loading.)
set -e
REPO="$(cd "$(dirname "$0")" && pwd)"
PROFILES="$HOME/Library/Application Support/Firefox"
REL=$(awk -F= '/^\[Install/{f=1} f&&/^Default=/{print $2; exit}' "$PROFILES/profiles.ini")
PROFILE="$PROFILES/$REL"
[ -d "$PROFILE" ] || { echo "Couldn't find your Firefox profile"; exit 1; }
rm -rf "$PROFILE/chrome"
cp -R "$REPO/chrome" "$PROFILE/chrome"
echo "Theme installed to $PROFILE/chrome — quit and reopen Firefox to see it."

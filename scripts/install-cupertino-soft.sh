#!/usr/bin/env bash
# Installer for Obsidian Cupertino Soft Theme, Linux.
set -euo pipefail
VAULT="${1:-$HOME/Dropbox/500-OBSIDIAN}"
BASE="https://raw.githubusercontent.com/vict0rg/cupertino-soft/main"
TARGET="$VAULT/.obsidian/themes/Cupertino Soft"
test -d "$VAULT/.obsidian" || { echo "Missing Obsidian vault: $VAULT" >&2; exit 2; }
command -v curl >/dev/null || { echo "curl is required" >&2; exit 2; }
mkdir -p "$TARGET"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
for file in manifest.json theme.css; do
  curl -fLsS --retry 3 "$BASE/$file" -o "$TMP/$file"
  test -s "$TMP/$file"
done
grep -q '"name": "Cupertino Soft"' "$TMP/manifest.json"
cp "$TMP/theme.css" "$TMP/manifest.json" "$TARGET/"
echo "Installed Cupertino Soft into $TARGET"
echo "Select Cupertino Soft in Obsidian > Settings > Appearance > Themes."

#!/usr/bin/env bash
# Install and activate Obsidian Cupertino Soft Theme without using the app menus.
# This script only updates theme files and the cssTheme key in appearance.json.
# Existing appearance settings, snippets, plugins, and notes are preserved.
set -euo pipefail

MODE="install"
VAULT="$HOME/Dropbox/500-OBSIDIAN"
if [[ "${1:-}" == "--reset" ]]; then
  MODE="reset"
  VAULT="${2:-$VAULT}"
elif [[ -n "${1:-}" ]]; then
  VAULT="$1"
fi

CFG="$VAULT/.obsidian"
APPEARANCE="$CFG/appearance.json"
if [[ ! -d "$CFG" ]]; then
  echo "Error: vault configuration not found: $CFG" >&2
  echo "Usage: bash install-and-activate.sh [vault-path] | --reset [vault-path]" >&2
  exit 2
fi

# Install before modifying the current selection; any network failure leaves
# the previously selected theme untouched.
if [[ "$MODE" == "install" ]]; then
  command -v curl >/dev/null || { echo "Error: curl is required" >&2; exit 2; }
  command -v python3 >/dev/null || { echo "Error: python3 is required" >&2; exit 2; }
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  BASE="https://raw.githubusercontent.com/vict0rg/cupertino-soft/main"
  for file in theme.css manifest.json; do
    curl --fail --silent --show-error --location --retry 3 "$BASE/$file" -o "$TMP/$file"
    test -s "$TMP/$file"
  done
  python3 - "$TMP/manifest.json" <<'PY'
import json,sys
manifest=json.load(open(sys.argv[1],encoding="utf-8"))
assert manifest["name"]=="Cupertino Soft", "Unexpected theme package"
PY
  TARGET="$CFG/themes/Cupertino Soft"
  mkdir -p "$TARGET"
  cp "$TMP/theme.css" "$TARGET/theme.css"
  cp "$TMP/manifest.json" "$TARGET/manifest.json"
fi

# Preserve all existing JSON fields; create one dated backup only if it exists.
python3 - "$APPEARANCE" "$MODE" <<'PY'
import json, os, pathlib, shutil, sys, tempfile, datetime
path=pathlib.Path(sys.argv[1])
mode=sys.argv[2]
if path.exists():
    data=json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data,dict):
        raise ValueError("appearance.json must be a JSON object")
    stamp=datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    backup=path.with_name("appearance.json.backup-"+stamp)
    suffix=0
    while backup.exists():
        suffix+=1
        backup=path.with_name("appearance.json.backup-"+stamp+f"-{suffix}")
    shutil.copy2(path,backup)
    print(f"Appearance backup: {backup}")
else:
    data={}
# Change only the CSS theme selection; do not touch snippets, fonts, or settings.
data["cssTheme"] = "Cupertino Soft" if mode=="install" else ""
with tempfile.NamedTemporaryFile("w",encoding="utf-8",dir=path.parent,
    prefix=".appearance.",suffix=".tmp",delete=False) as handle:
    temp=pathlib.Path(handle.name)
    json.dump(data,handle,ensure_ascii=False,indent=2)
    handle.write("\n")
try:
    if path.exists():
        os.chmod(temp,path.stat().st_mode)
    os.replace(temp,path)
finally:
    if temp.exists():
        temp.unlink()
print("Theme selection:",data["cssTheme"] or "Default")
PY
echo "Restart Obsidian to apply the new appearance."
if [[ "$MODE" == "install" ]]; then
  echo "Installed/activated Cupertino Soft in $VAULT"
else
  echo "Returned to the Obsidian default theme in $VAULT"
fi

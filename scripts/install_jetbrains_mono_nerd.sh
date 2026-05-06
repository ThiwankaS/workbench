#!/usr/bin/env bash
# Install JetBrainsMono Nerd Font for local user (~/.local/share/fonts).
set -euo pipefail

# Pin to a tested release tag (override: TAG=v3.x.y ./install_jetbrains_mono_nerd.sh)
TAG="${TAG:-v3.4.0}"
DESTDIR="${DESTDIR:-$HOME/.local/share/fonts/JetBrainsMonoNerd}"

mkdir -p "$DESTDIR"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

zip="$tmpdir/JetBrainsMono.zip"
url="https://github.com/ryanoasis/nerd-fonts/releases/download/${TAG}/JetBrainsMono.zip"

echo "Downloading $url"
curl -fsSL -o "$zip" "$url"

unzip -q "$zip" -d "$tmpdir/extract"
find "$tmpdir/extract" -type f \( -name '*.ttf' -o -name '*.otf' \) -exec cp {} "$DESTDIR" \;

if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$HOME/.local/share/fonts"
  echo "fc-cache updated."
else
  echo "fc-cache not found; restart apps or log out/in to pick up fonts."
fi

echo "Installed to $DESTDIR — set your terminal to 'JetBrainsMono Nerd Font' (or similar)."

#!/usr/bin/env bash
# Install snap.nvim backend (binary + playwright + node_modules/playwright-core).
# Required for :Snap / <leader>ss. Run after :Lazy sync if SnapInstall fails.

set -euo pipefail

VERSION="${SNAP_VERSION:-v1.5.0}"
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) PLAT="linux-x86_64" ;;
  aarch64) PLAT="linux-aarch64" ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

BIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/snap.nvim/bin"
ARCHIVE="snap-nvim-${PLAT}.tar.gz"
URL="https://github.com/mistweaverco/snap.nvim/releases/download/${VERSION}/${ARCHIVE}"
TMP="$(mktemp -d)"

cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1" >&2
    exit 1
  }
}

need curl
need tar

mkdir -p "$TMP/extract" "$BIN_DIR"
echo "Downloading ${URL} ..."
curl -fL --progress-bar -o "$TMP/archive.tar.gz" "$URL"
tar -xzf "$TMP/archive.tar.gz" -C "$TMP/extract"

for item in "snap-nvim-${PLAT}" playwright node_modules; do
  [[ -e "$TMP/extract/$item" ]] || {
    echo "Archive missing required path: $item" >&2
    exit 1
  }
done

rm -rf "$BIN_DIR/snap-nvim" "$BIN_DIR/playwright" "$BIN_DIR/node_modules"
cp "$TMP/extract/snap-nvim-${PLAT}" "$BIN_DIR/snap-nvim"
chmod +x "$BIN_DIR/snap-nvim"
cp -a "$TMP/extract/playwright" "$BIN_DIR/"
cp -a "$TMP/extract/node_modules" "$BIN_DIR/"
echo "${VERSION#v}" > "$BIN_DIR/version.txt"

echo "Installed to $BIN_DIR"
"$BIN_DIR/snap-nvim" health

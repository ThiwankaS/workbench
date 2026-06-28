#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${TARGET_DIR:-$HOME/.config/nvim}"
BACKUP_SUFFIX="$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }

install_packages_linux() {
  if command -v apt-get >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y neovim git curl gcc make ripgrep fd-find tree-sitter
  elif command -v dnf >/dev/null; then
    sudo dnf install -y neovim git curl gcc make ripgrep fd-find tree-sitter
  elif command -v pacman >/dev/null; then
    sudo pacman -Sy --noconfirm neovim git curl gcc make ripgrep fd tree-sitter
  else
    warn "Install manually: neovim git curl gcc ripgrep fd tree-sitter"
  fi
}

prepare_config() {
  if [[ -e "$TARGET_DIR" && "$(realpath "$TARGET_DIR")" != "$REPO_DIR" ]]; then
    info "Backing up $TARGET_DIR → ${TARGET_DIR}.backup.${BACKUP_SUFFIX}"
    mv "$TARGET_DIR" "${TARGET_DIR}.backup.${BACKUP_SUFFIX}"
  fi
  if [[ "$(realpath "$TARGET_DIR" 2>/dev/null || true)" != "$REPO_DIR" ]]; then
    cp -a "$REPO_DIR" "$TARGET_DIR"
  fi
}

prime_neovim() {
  info "Syncing plugins"
  nvim --headless "+Lazy! sync" +qa || warn "Run :Lazy sync inside Neovim"
  info "Installing Treesitter parsers"
  nvim --headless "+lua require('nvim-treesitter').install({'c','cpp','javascript','python','asm','lua','vim','vimdoc','bash','json'})" +qa \
    || warn "Run :TSInstall c cpp javascript python asm in Neovim"
}

main() {
  info "Bootstrapping CoreForge Workbench"
  install_packages_linux
  prepare_config
  prime_neovim
  cat <<'EOF'

Done.
  nvim
  :Mason          " verify clangd, ts_ls, pyright, asm-lsp
  :checkhealth

Guide: xdg-open ~/.config/nvim/workbench.html

EOF
}

main "$@"

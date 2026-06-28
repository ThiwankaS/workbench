#!/usr/bin/env bash
set -euo pipefail

# One-command bootstrap for this Neovim config.
# - Installs Neovim + required tools
# - Backs up existing ~/.config/nvim
# - Copies this repo to ~/.config/nvim (unless already there)
# - Installs plugins and Treesitter parsers headlessly

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${TARGET_DIR:-$HOME/.config/nvim}"
BACKUP_SUFFIX="$(date +%Y%m%d-%H%M%S)"

have() {
  command -v "$1" >/dev/null 2>&1
}

info() {
  printf '\033[1;34m[INFO]\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33m[WARN]\033[0m %s\n' "$*"
}

run_sudo() {
  if have sudo; then
    sudo "$@"
  else
    "$@"
  fi
}

install_packages_linux() {
  if have apt-get; then
    run_sudo apt-get update
    run_sudo apt-get install -y neovim git curl unzip xz-utils tar gcc make ripgrep fd-find tree-sitter
  elif have dnf; then
    run_sudo dnf install -y neovim git curl unzip xz tar gcc make ripgrep fd-find tree-sitter
  elif have pacman; then
    run_sudo pacman -Sy --noconfirm neovim git curl unzip xz tar gcc make ripgrep fd tree-sitter
  elif have zypper; then
    run_sudo zypper --non-interactive install neovim git curl unzip xz tar gcc make ripgrep fd tree-sitter
  else
    warn "Unsupported Linux package manager. Install manually: neovim git curl unzip tar gcc ripgrep fd tree-sitter"
  fi
}

install_packages_macos() {
  if ! have brew; then
    warn "Homebrew not found. Install brew first: https://brew.sh"
    return
  fi
  brew install neovim git curl unzip ripgrep fd tree-sitter
}

install_base_tools() {
  local os
  os="$(uname -s)"
  case "$os" in
    Linux) install_packages_linux ;;
    Darwin) install_packages_macos ;;
    *)
      warn "Unsupported OS ($os). Install dependencies manually."
      ;;
  esac
}

prepare_config_dir() {
  mkdir -p "$(dirname "$TARGET_DIR")"

  if [[ -e "$TARGET_DIR" && "$(realpath "$TARGET_DIR")" != "$REPO_DIR" ]]; then
    local backup="${TARGET_DIR}.backup.${BACKUP_SUFFIX}"
    info "Backing up existing config to: $backup"
    mv "$TARGET_DIR" "$backup"
  fi

  if [[ "$(realpath "$TARGET_DIR" 2>/dev/null || true)" != "$REPO_DIR" ]]; then
    info "Copying config to $TARGET_DIR"
    cp -a "$REPO_DIR" "$TARGET_DIR"
  else
    info "Using existing repo in $TARGET_DIR"
  fi
}

install_font_optional() {
  if [[ -x "$TARGET_DIR/scripts/install_jetbrains_mono_nerd.sh" ]]; then
    info "Installing JetBrainsMono Nerd Font (optional but recommended)"
    "$TARGET_DIR/scripts/install_jetbrains_mono_nerd.sh" || warn "Font install failed; continuing"
  fi
}

prime_neovim() {
  info "Installing plugins (Lazy sync)"
  nvim --headless "+Lazy! sync" +qa || {
    warn "Lazy sync failed in headless mode. Open nvim and run :Lazy sync manually."
    return
  }

  info "Installing Treesitter parsers (c cpp javascript typescript markdown lua)"
  nvim --headless "+lua require('nvim-treesitter').install({'c','cpp','javascript','typescript','markdown','markdown_inline','lua','vim','vimdoc','bash','json'})" +qa \
    || warn "Treesitter install failed; run :TSInstall c cpp in Neovim."
}

main() {
  info "Bootstrapping Neovim + config"
  install_base_tools
  prepare_config_dir
  install_font_optional
  prime_neovim

  cat <<'EOF'

Done.
Next steps:
  1) Open Neovim: nvim
  2) :Mason — verify clangd, clang-format, stylua, ts_ls, etc.
  3) :checkhealth
  4) Optional: :Lazy clean — remove orphaned plugins from old installs
  5) User guide: xdg-open ~/.config/nvim/workbench.html

EOF
}

main "$@"

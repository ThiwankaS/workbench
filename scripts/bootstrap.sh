#!/usr/bin/env bash
# Debian 13 — dependencies for Neovim 0.12 + vim.pack config
set -euo pipefail

info() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!>\033[0m %s\n' "$*"; }

if command -v apt-get >/dev/null 2>&1; then
  info "Installing packages (sudo may prompt)"
  sudo apt-get update
  sudo apt-get install -y \
    neovim git curl ca-certificates \
    build-essential \
    ripgrep fd-find \
    tree-sitter
else
  warn "apt-get not found — install neovim, git, ripgrep, fd, gcc manually"
fi

info "Installing JetBrains Mono Nerd Font"
bash "$(dirname "$0")/install_jetbrains_mono_nerd.sh"

info "First Neovim start downloads plugins via vim.pack (press y if prompted)"
info "Then run: nvim"
info "Inside nvim: :checkhealth vim.pack  :Mason  :checkhealth"

# CoreForge Workbench

Minimal **Neovim 0.12** config using the built-in **[vim.pack](https://neovim.io/doc/user/pack.html)** plugin manager.

Focus: **C**, **C++**, **JavaScript**, **Python** — Gruvbox Material, Treesitter, Telescope, nvim-tree, Mason LSP, NvChad-style UI.

## Documentation

- **Web guide:** https://thiwankas.github.io/workbench/
- **Local guide:** `xdg-open ~/.config/nvim/workbench.html`

## Requirements

- Neovim **≥ 0.12** (with `vim.pack`)
- `git`, `ripgrep` (for live grep), `gcc` / `clang` (for Treesitter parsers)

## Quick start (Debian 13)

```bash
git clone https://github.com/ThiwankaS/workbench.git ~/.config/nvim
cd ~/.config/nvim
bash ./scripts/bootstrap.sh
nvim
```

On first launch, `vim.pack` installs plugins. Confirm with `y` (or `a` for all) if prompted.

```vim
:checkhealth vim.pack
:Mason
:TSInstall c cpp javascript python
```

Set your **terminal font** to `JetBrainsMono Nerd Font` (required for icons and slanted tabs).

## Layout

```
~/.config/nvim/
├── init.lua                 vim.pack.add + bootstrap
├── nvim-pack-lock.json      plugin lockfile (commit this)
├── workbench.html           full reference guide
├── lua/
│   ├── core/
│   │   ├── options.lua      editor defaults
│   │   ├── keymaps.lua      leader maps + LSP
│   │   └── font.lua         GUI font
│   └── setup/
│       ├── theme.lua        gruvbox-material
│       ├── treesitter.lua
│       ├── tree.lua         nvim-tree
│       ├── telescope.lua
│       ├── lsp.lua          clangd, ts_ls, pyright
│       ├── cmp.lua
│       └── chrome.lua       tabline + statusline (NvChad-style)
└── scripts/
    ├── bootstrap.sh
    └── install_jetbrains_mono_nerd.sh
```

## Keymaps

| Keys | Action |
|------|--------|
| `Space e` | Toggle file tree |
| `Space E` | Reveal file in tree |
| `Space ff` | Find files |
| `Space fg` | Live grep |
| `Space fb` | Buffers |
| `Space fr` | Recent files |
| `Space cf` | Format (LSP) |
| `Space d` | Diagnostic float |
| `gd` | Go to definition |
| `K` | Hover |
| `Ctrl h/j/k/l` | Move between windows |
| `Ctrl+u` / `Ctrl+l` | Uppercase / lowercase word (insert mode) |

## Plugin management

```vim
:lua vim.pack.update()
:lua vim.pack.update(nil, { force = true })
:checkhealth vim.pack
```

## LSP servers (via Mason)

| Language | Server |
|----------|--------|
| C / C++ | clangd |
| JavaScript / TypeScript | typescript-language-server (`ts_ls`) |
| Python | pyright |

C/C++ needs `compile_commands.json` in the project root for full clangd support.

## Theme

[sainnhe/gruvbox-material](https://github.com/sainnhe/gruvbox-material) — hard background, material foreground.

Edit `lua/setup/theme.lua` to tweak `vim.g.gruvbox_material_*` options.

## NvChad-style UI

`lua/setup/chrome.lua` provides bufferline tabs, gitsigns, and a powerline statusline (no full NvChad / lazy.nvim stack).

Persistent undo is stored in `~/.config/nvim/undodir/` (gitignored).

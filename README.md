# CoreForge Workbench

Minimal Neovim configuration for **C**, **C++**, **JavaScript**, **Python**, and **Assembly**.

## Structure

```
~/.config/nvim/
├── init.lua              Options and lazy.nvim bootstrap
├── lua/
│   ├── keymaps.lua       Keybindings
│   ├── plugins.lua       Plugin specifications
│   ├── treesitter.lua    Syntax, indent, parsers
│   ├── chrome.lua        NvChad-style statusline + tab bar
│   ├── font.lua          JetBrains Mono Nerd Font
│   └── nvim_tree.lua     Sidebar file tree
└── workbench.html        Full reference guide
```

## Installation

```bash
bash ./scripts/bootstrap.sh
bash ./scripts/install_jetbrains_mono_nerd.sh   # optional — Nerd Font icons
nvim
```

Inside Neovim:

```vim
:Lazy sync
:Mason
:checkhealth
```

Set your **terminal font** to `JetBrainsMono Nerd Font` (GUI Neovim picks it up from `lua/font.lua`).

## Documentation

- **Web:** https://thiwankas.github.io/workbench/
- **Local:** `xdg-open ~/.config/nvim/workbench.html`

## Chrome UI (statusline + tabs)

Bottom bar: mode · file · git branch · errors/warnings · LSP · project · clock · line/col.

Top tab bar: bufferline (file tabs with LSP indicators).

## File tree

| Keys | Action |
|------|--------|
| `Space e` | Toggle sidebar file tree |
| `Space E` | Reveal current file in tree |

## Stack

| Component | Plugin / module |
|-----------|-----------------|
| Theme | gruvbox.nvim |
| Syntax | nvim-treesitter · `lua/treesitter.lua` |
| UI chrome | bufferline + gitsigns · `lua/chrome.lua` |
| Font | `lua/font.lua` |
| File tree | nvim-tree · `lua/nvim_tree.lua` |
| Search | telescope.nvim |
| LSP | mason + nvim-lspconfig |
| Completion | nvim-cmp |

## Language servers

| Language | Server |
|----------|--------|
| C / C++ | clangd |
| JavaScript / TypeScript | ts_ls |
| Python | pyright |
| Assembly | asm_lsp |

C/C++ projects require `compile_commands.json` in the project root for full clangd support.

## Editing shortcuts

| Keys (insert mode) | Action |
|--------------------|--------|
| `Ctrl+u` | Uppercase word under cursor |
| `Ctrl+l` | Lowercase word under cursor |

Persistent undo is stored in `~/.config/nvim/undodir/` (gitignored).

# CoreForge Workbench

Minimal Neovim configuration for **C**, **C++**, **JavaScript**, **Python**, and **Assembly**.

## Structure

```
~/.config/nvim/
├── init.lua          Options and lazy.nvim bootstrap
├── lua/
│   ├── keymaps.lua   Keybindings
│   └── plugins.lua   Plugin specifications
└── workbench.html    Full reference guide
```

## Installation

```bash
bash ./scripts/bootstrap.sh
nvim
```

Inside Neovim:

```vim
:Lazy sync
:Mason
:checkhealth
```

## Documentation

- **Web:** https://thiwankas.github.io/workbench/
- **Local:** `xdg-open ~/.config/nvim/workbench.html`

## Stack

| Component | Plugin |
|-----------|--------|
| Theme | gruvbox.nvim |
| Syntax | nvim-treesitter |
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

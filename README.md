# Thiwanka's Workbench

Personal Neovim setup — **NvChad v2.5** + **Lazy.nvim**, tuned for desktop C++, ESP-IDF embedded, LSP, DAP, and snap.nvim.

**Author:** [ThiwankaS](https://github.com/ThiwankaS) · [github.com/ThiwankaS/workbench](https://github.com/ThiwankaS/workbench)

## Quick start

```bash
bash ./scripts/bootstrap.sh
nvim
```

Then run `:Mason` and `:checkhealth`.

## Documentation

**Full guide & cheat sheet:** open [`workbench.html`](workbench.html) in your browser (HTML + `assets/workbench/` CSS/JS).

```bash
xdg-open ~/.config/nvim/workbench.html
```

From Neovim:

```vim
:!xdg-open ~/.config/nvim/workbench.html
```

| | |
|---|---|
| **Leader** | `Space` |
| **Theme** | Gruvbox — `<leader>th` to switch |
| **Font** | JetBrainsMono Nerd Font |
| **Focus** | C/C++ · ESP-IDF · Linux |
| **Discover keys** | Press `<leader>` and pause (Which-key) |

## Daily picks

| Keys | Action |
|------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>e` | Toggle file tree |
| `<leader>cf` | Format buffer |
| `<leader>ss` | Code snapshot |
| `<leader>gg` | Lazygit |
| `:lsp restart` | Restart LSP |

See **workbench.html** for the full personal reference.

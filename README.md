# CoreForge Workbench

Minimal Neovim setup by **ThiwankaS** — NvChad v2.5 + Lazy.nvim, tuned for **C/C++**, **TypeScript/JavaScript**, and **Markdown**.

## Start Here

- **Website:** [https://thiwankas.github.io/workbench/](https://thiwankas.github.io/workbench/)
- **Local guide:** `xdg-open ~/.config/nvim/workbench.html`

## Quick Install

```bash
bash ./scripts/bootstrap.sh
nvim
```

Then in Neovim:

```vim
:Mason
:checkhealth
:Lazy clean    " optional — prune removed plugins from disk
```

## What's Included

| Layer | Plugins |
|-------|---------|
| **UI** | NvChad (base46, ui), indent-blankline, gitsigns, which-key |
| **Navigation** | Telescope, nvim-tree, vim-tmux-navigator |
| **Syntax** | nvim-treesitter (c, cpp, js/ts, markdown, lua, …) |
| **LSP** | Mason + mason-tool-installer, nvim-lspconfig, blink.cmp |
| **Editing** | conform.nvim, nvim-autopairs, Comment.nvim |
| **Git** | lazygit.nvim, gitsigns |

**Not included** (removed to reduce conflicts and startup cost): snacks.nvim, DAP stack, snap.nvim, godbolt, mark.nvim, aerial, mini.map, vim-visual-multi, nvim-cmp.

## Key Bindings (cheat sheet)

| Keys | Action |
|------|--------|
| `Space` `ff` / `fg` / `fr` / `fb` | Telescope find / grep / recent / buffers |
| `Space` `e` / `ef` | Toggle tree / reveal file |
| `Space` `cf` / `fm` / `gq` | Format (Conform) / Format / LSP format |
| `Space` `gg` / `gf` / `gl` | Lazygit / file / log |
| `Alt+j` / `Alt+k` | Move line or selection (`Space` `md` / `mu` fallback) |
| `Tab` (insert) | Completion next → snippet → indent |
| `Ctrl+h/j/k/l` | Tmux / split navigation |

Full reference: **`workbench.html`**

## Config Layout

```
~/.config/nvim/
├── init.lua
├── workbench.html          ← user guide
├── lua/
│   ├── chadrc.lua          Gruvbox + base46
│   ├── mappings.lua        keymaps
│   ├── options.lua
│   ├── autocmds.lua
│   ├── config/             theme, format, ts_compat
│   ├── configs/            lazy, lsp, conform
│   └── plugins/            blink, treesitter, telescope, …
└── scripts/
    ├── bootstrap.sh
    └── install_jetbrains_mono_nerd.sh
```

## Theme & Syntax Colors

Edit `lua/config/theme.lua`, then:

```vim
:WorkbenchThemeReload
```

## C/C++ Notes

- Generate `compile_commands.json` (CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`)
- ESP-IDF: set `CLANGD_QUERY_DRIVER` for cross-GCC (see workbench **C/C++** section)
- `:lsp restart clangd` after toolchain changes

## Publishing the Guide

See [docs/GITHUB_PAGES.md](docs/GITHUB_PAGES.md).

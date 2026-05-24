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

**Live site (renders as a webpage):** [thiwankas.github.io/workbench](https://thiwankas.github.io/workbench/)

GitHub’s file browser always shows HTML as **source code** (security). Use the link above — same experience as `xdg-open` locally.

**Local file:**

```bash
xdg-open ~/.config/nvim/workbench.html
```

From Neovim:

```vim
:!xdg-open ~/.config/nvim/workbench.html
```

### GitHub Pages (one-time)

After you push, enable Pages once:

1. Repo **Settings** → **Pages**
2. **Build and deployment** → **Source:** **GitHub Actions**
3. Push to `main` — workflow `.github/workflows/pages.yml` deploys `workbench.html` + `assets/`

Site files: `index.html` (redirect), `workbench.html`, `assets/workbench/`.

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

See the [live workbench](https://thiwankas.github.io/workbench/) or **workbench.html** locally for the full reference.

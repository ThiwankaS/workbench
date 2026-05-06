# Neovim Config (NvChad + Lazy.nvim)

Daily-driver IDE-style setup on **Neovim 0.10+**: NvChad UI/theme pipeline (**base46**), **Lazy.nvim** for plugins, strong LSP, Treesitter, Telescope, Mason-built tooling, optional CodeLLDB debugging.

- **Leader:** `Space`
- **Theme:** Catppuccin via NvChad base46 (`lua/chadrc.lua`), plus Treesitter tweaks from `vim.theme.syntax` in `lua/config/theme.lua`
- **Plugins:** NvChad core (`NvChad/NvChad`, branch `v2.5`) + specs under `lua/plugins/*.lua`

NvChad does **not** replace Lazy.nvim — it is a base distribution that **uses** Lazy.nvim to load itself and your extras.

---

## Migration checklist (complete these in order)

Use this if you are upgrading from an older checkout (flat `lua/config/*` only, standalone Catppuccin/LSP files, etc.) or cloning this repo on a new machine.

### 1. Back up

```bash
cp -a ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)
```

Optional: export old pins if you rely on them:

```bash
cp ~/.config/nvim/lazy-lock.json ~/lazy-lock.json.backup 2>/dev/null || true
```

### 2. Pull / sync the new layout

From your repo root:

```bash
cd ~/.config/nvim
git pull   # or merge/rebase your migration branch
```

Confirm these exist:

- `init.lua` bootstraps Lazy then **`NvChad/NvChad`**
- `lua/chadrc.lua`, `lua/options.lua`, `lua/mappings.lua`, `lua/autocmds.lua`
- `lua/configs/lazy.lua`, `lua/configs/conform.lua`, `lua/configs/lspconfig.lua`
- `lua/plugins/init.lua` (Conform + LSP hook)

### 3. Install fonts (recommended)

```bash
bash ~/.config/nvim/scripts/install_jetbrains_mono_nerd.sh
```

Set your terminal emulator to **JetBrainsMono Nerd Font** (exact name may vary; pick an NF/Nerd face).

### 4. First Neovim run — fetch plugins

```bash
nvim
```

Inside Neovim:

```
:Lazy sync
```

Wait until Lazy finishes (NvChad, base46, Mason, your extras). Expect **`lazy-lock.json`** to change.

### 5. Mason tools (LSP + debugger + formatters)

```
:Mason
```

Install or verify at least:

- **clangd**, **clang-format**, **lua-language-server**, **typescript-language-server**, **pyright**, **bash-language-server**, **marksman**, **stylua**, **codelldb**

This repo also enables **`mason-tool-installer`** (`lua/plugins/mason_tools.lua`) to queue installs automatically after Mason loads.

### 6. Treesitter parsers

```
:TSInstall cpp c lua vim bash python json yaml cmake make markdown markdown_inline javascript typescript regex
```

Or rely on **`lua/plugins/treesitter.lua`** ensure lists + `:TSUpdate` when prompted.

### 7. Health checks

```
:checkhealth
```

Fix anything marked **ERROR**. **Warnings** are often safe to ignore.

### 8. Reload theme / caches if UI looks wrong

Quit and restart Neovim once so **base46** caches under `stdpath('data')/base46/` settle.

### 9. Optional: format-on-save

Edit **`lua/config/format.lua`** — set `format_on_save = true` if you want Conform to format on write (uses clang-format for C/C++, stylua for Lua).

### 10. Optional: project clang style

Add a **`.clang-format`** at your repo root (clang-format uses `-style=file` when present). Fallback defaults live in **`lua/config/format.lua`** (`clang_format_fallback_style`).

---

## Troubleshooting: Treesitter query errors

If `:checkhealth` reports **ERROR** for `highlights` / `locals` / `folds` / … for **cpp**, **bash**, **html**, etc., and paths mention **`~/.local/share/nvim/site/queries/`**, you usually have **old or conflicting** query files that fight the queries bundled with **`nvim-treesitter`**.

**Fix (non-destructive backup):**

```bash
# Move aside any legacy overrides (nvim-treesitter ships queries inside the plugin / runtime)
mv ~/.local/share/nvim/site/queries \
  ~/.local/share/nvim/site/queries.bak.$(date +%Y%m%d) 2>/dev/null || true
```

This repo only adds **intentional** overrides under **`~/.config/nvim/queries/`** (e.g. `c/highlights.scm` with `; extends`). Restart Neovim and run `:checkhealth` again.

---

## Stability (pinned plugins)

- Commits are pinned in **`lazy-lock.json`**.
- Lazy’s background checker is off (`lua/configs/lazy.lua`).
- Luarocks integration is off.

**Update workflow:** back up → `:Lazy sync` when you choose → `:checkhealth` → test real projects.

---

## Directory layout (current)

```text
~/.config/nvim
├── init.lua                 # Lazy bootstrap + NvChad + load options/autocmds/mappings
├── lazy-lock.json
├── README.md
├── scripts/
│   └── install_jetbrains_mono_nerd.sh
├── extras/
│   └── tmux_split_help.txt
├── queries/
│   └── c/highlights.scm     # Extra Treesitter highlights (#pragma args, etc.)
├── lua/
│   ├── chadrc.lua           # NvChad theme + hl_override (ties to vim.theme.syntax)
│   ├── options.lua          # nvchad.options + your UI/editing options
│   ├── mappings.lua         # nvchad.mappings + your keymaps
│   ├── autocmds.lua         # nvchad.autocmds + asm/qflist helpers
│   ├── configs/
│   │   ├── lazy.lua         # Lazy.nvim UI + lockfile + perf rtp tweaks
│   │   ├── conform.lua      # Conform (clang-format, stylua, …)
│   │   └── lspconfig.lua    # Extra vim.lsp.enable servers after NvChad defaults
│   ├── config/
│   │   ├── theme.lua        # vim.theme.syntax — palette names for Treesitter tweaks
│   │   ├── format.lua       # clang-format / format-on-save knobs
│   │   └── ts_compat.lua    # Legacy nvim-treesitter.configs shim (Telescope previews)
│   └── plugins/
│       ├── init.lua         # Conform + nvim-lspconfig hooks (merge with NvChad)
│       ├── telescope.lua
│       ├── treesitter.lua
│       ├── coding.lua       # Comment.nvim, mini.move
│       ├── tree.lua
│       ├── snacks.lua       # snacks + lazygit keys
│       ├── tmux.lua
│       ├── dap.lua          # nvim-dap + codelldb + dap-ui
│       ├── mason_tools.lua  # mason-tool-installer
│       └── …                # godbolt, markdown, aerial, minimap, multicursor, …
└── undodir/                 # persistent undo (created automatically)
```

---

## Plugin catalog (upstream on GitHub)

Core stack and tools this config builds on:

| Project | GitHub | Role here |
|---------|--------|-----------|
| **NvChad** | [github.com/NvChad/NvChad](https://github.com/NvChad/NvChad) | UI, base46 theme, default LSP/cmp/treesitter wiring |
| **Lazy.nvim** | [github.com/folke/lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager (bootstrap in `init.lua`) |
| **Mason** | [github.com/mason-org/mason.nvim](https://github.com/mason-org/mason.nvim) | Install language servers & tools |
| **nvim-lspconfig** | [github.com/neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configs |
| **Conform** | [github.com/stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting (clang-format, stylua) — `lua/configs/conform.lua` |
| **nvim-treesitter** | [github.com/nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parsing / highlights |
| **Telescope** | [github.com/nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder — `lua/plugins/telescope.lua` |
| **nvim-tree** | [github.com/nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File tree — `lua/plugins/tree.lua` |
| **Comment.nvim** | [github.com/numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) | Comments — `lua/plugins/coding.lua` |
| **mini.nvim** (move, map) | [github.com/echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim) | Line move + minimap — `coding.lua`, `minimap.lua` |
| **Snacks** | [github.com/folke/snacks.nvim](https://github.com/folke/snacks.nvim) | Dashboard, notifier, picker helpers — `lua/plugins/snacks.lua` |
| **lazygit.nvim** | [github.com/kdheepak/lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | Lazygit from Neovim — keys in `snacks.lua` |
| **vim-tmux-navigator** | [github.com/christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Ctrl+hjkl across splits/tmux — `lua/plugins/tmux.lua` |
| **Aerial** | [github.com/stevearc/aerial.nvim](https://github.com/stevearc/aerial.nvim) | Symbol outline — `lua/plugins/aerial.lua` |
| **vim-visual-multi** | [github.com/mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi) | Multi-cursor — `lua/plugins/multicursor.lua` |
| **mark.nvim** | [github.com/roerohan/mark.nvim](https://github.com/roerohan/mark.nvim) | Markdown preview — `lua/plugins/markdown.lua` |
| **godbolt.nvim** | [github.com/p00f/godbolt.nvim](https://github.com/p00f/godbolt.nvim) | Compiler Explorer — `lua/plugins/godbolt.lua` |
| **nvim-dap** | [github.com/mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debugger protocol |
| **mason-nvim-dap** | [github.com/jay-babu/mason-nvim-dap.nvim](https://github.com/jay-babu/mason-nvim-dap.nvim) | Mason integration for adapters (codelldb) |
| **nvim-dap-ui** | [github.com/rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | Debug UI |
| **mason-tool-installer** | [github.com/WhoIsSethDaniel/mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Batch Mason installs — `lua/plugins/mason_tools.lua` |

**Discover keys at runtime:** press `<leader>` and pause — **Which Key** (from NvChad) lists groups. Exact LSP maps follow NvChad defaults (`gd`, `gD`, hover, etc.) plus anything you add under `lua/mappings.lua`.

---

## Productivity habits

- Open projects with `nvim .`.
- Prefer Telescope (`<leader>ff`, `<leader>fg`) before relying only on the tree.
- Use `<leader>e` for nvim-tree; `Ctrl+h/j/k/l` moves between splits and tmux panes (`vim-tmux-navigator`).
- Use Lazygit (`<leader>gg`) for git-heavy flows.

---

## Keybindings reference (`Space` = leader)

### Command line, Telescope, tree

| Keys | Action | Config |
|------|--------|--------|
| `<leader><leader>` | Open command line (`:`) | `lua/mappings.lua` |
| `<leader>ff` | Find files | `lua/plugins/telescope.lua` |
| `<leader>fg` | Live grep | idem |
| `<leader>fr` | Recent files | idem |
| `<leader>fb` | Open buffers picker | idem |
| `<leader>fc` | Telescope command palette | idem |
| `<leader>:` | Command history (Telescope) | idem |
| `<leader>e` | Toggle nvim-tree | `lua/plugins/tree.lua` |
| `<leader>ef` | Reveal current file in tree | idem |

**In nvim-tree buffer:** `l` open, `h` close parent, `H` collapse all (plus plugin defaults for add/delete/rename — see nvim-tree docs).

### Working directory

| Keys | Action | Config |
|------|--------|--------|
| `<leader>cd` | `lcd` to current buffer’s directory | `lua/mappings.lua` |
| `<leader>cW` | Global `:cd` to current file’s directory | `lua/plugins/telescope.lua` |

### Editing & formatting

| Keys | Action | Config |
|------|--------|--------|
| `gcc` | Toggle line comment | Comment.nvim — `lua/plugins/coding.lua` |
| `gc` (visual) | Toggle comment on selection | idem |
| `Alt+j` / `Alt+k` | Move line or selection | mini.move — `coding.lua` |
| `<Esc>` | Clear search highlight | `mappings.lua` |
| `<C-a>` | Select all | `mappings.lua` |
| `<` / `>` (visual) | Indent and keep selection | `mappings.lua` |
| `<C-u>` / `<C-l>` (insert) | Uppercase / lowercase word | `mappings.lua` |
| `<leader>cf` | Format with **Conform** (clang-format / stylua, …) | `mappings.lua` |
| `<leader>gq` | Format via **LSP** | `mappings.lua` |

### Buffers, splits, terminal, tmux

| Keys | Action | Config |
|------|--------|--------|
| `L` / `H` | Next / previous buffer | `mappings.lua` |
| `<leader>x` | Close buffer | `mappings.lua` |
| `<leader>t-` | Horizontal split + terminal | `mappings.lua` |
| `<leader>t\` | Vertical split + terminal | `mappings.lua` |
| `<Esc><Esc>` | Exit terminal insert → Normal | `mappings.lua` |
| `Ctrl+h` / `j` / `k` / `l` | Focus window or tmux pane | `lua/plugins/tmux.lua` |

See also **`extras/tmux_split_help.txt`** for tmux prefix + split keys.

### LSP (NvChad defaults + Mason)

| Keys / command | Action |
|----------------|--------|
| `gd`, `gD`, `K`, workspace folders, type def | NvChad `lua/nvchad/configs/lspconfig.lua` defaults |
| `:Mason` | Install/update **clangd**, **codelldb**, etc. |

Use **Which Key** after `<leader>` for the full NvChad menu.

### Debugging (CodeLLDB via Mason)

| Keys | Action | Config |
|------|--------|--------|
| `<leader>db` | Toggle breakpoint | `lua/plugins/dap.lua` |
| `<leader>dB` | Conditional breakpoint | idem |
| `<leader>dc` | Continue / start | idem |
| `<leader>dC` | Terminate | idem |
| `<leader>do` | Step over | idem |
| `<leader>di` | Step into | idem |
| `<leader>dO` | Step out | idem |
| `<leader>dl` | Run last | idem |
| `<leader>du` | Toggle DAP UI | idem |

### Git (lazygit.nvim)

| Keys | Action | Config |
|------|--------|--------|
| `<leader>gg` | Lazygit (repo) | `lua/plugins/snacks.lua` |
| `<leader>gf` | Lazygit current file | idem |
| `<leader>gl` | Lazygit log | idem |
| `<leader>go` | Open `origin` URL in browser | idem |

### Markdown, outline, minimap, multicursor, Godbolt

| Keys | Action | Config |
|------|--------|--------|
| `<leader>mp` | Toggle markdown preview | `lua/plugins/markdown.lua` |
| `<leader>a` | Toggle **Aerial** symbol outline | `lua/plugins/aerial.lua` |
| `<leader>mo` / `<leader>mc` | Open / close **mini.map** | `lua/plugins/minimap.lua` |
| `<C-d>` | Visual-multi: add cursor / find under | `lua/plugins/multicursor.lua` |
| `<leader>va` | Visual-multi: select all matches | idem |
| `:Godbolt`, `:GodboltCompiler`, `:GodboltRun`, `:GodboltOpen` | Compiler Explorer | `lua/plugins/godbolt.lua` |

### Assembly buffers (`asm` / `gas` / `nasm`)

| Keys | Action | Config |
|------|--------|--------|
| `]m` / `[m` | Next / previous label | `lua/autocmds.lua` |
| `<leader>al` | Quickfix list of labels | idem |

### Theme / syntax tweaks

Edit **`lua/config/theme.lua`** (`vim.theme.syntax`, or shortcuts `vim.theme.keyword`, `vim.theme.type`, `vim.theme.preproc`). **`lua/chadrc.lua`** applies **`hl_override`** from those names. Restart Neovim after changes.

---

## First-time setup (short)

1. `nvim` → `:Lazy sync`
2. `:Mason` → install tools (or wait for mason-tool-installer)
3. `:TSUpdate` / `:TSInstall …` as needed (include **`regex`** if Snacks warns)
4. `:checkhealth` — fix **ERROR**, skim **WARNING**

## Recovery

- Plugins: `:Lazy sync`
- Parsers: `:TSUpdate`
- Broken plugin dir: remove `~/.local/share/nvim/lazy/<name>` and `:Lazy sync`
- Bad Treesitter queries: [Troubleshooting](#troubleshooting-treesitter-query-errors) above

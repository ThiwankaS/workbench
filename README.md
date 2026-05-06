# Neovim Config (NvChad + Lazy.nvim)

Custom Neovim setup based on **NvChad v2.5** with Lazy.nvim, LSP, Treesitter, formatting, DAP, and C/C++ friendly defaults.

- **Leader key:** `Space`
- **Default theme:** `catppuccin`
- **Theme picker:** `<leader>th`
- **Main config root:** `~/.config/nvim`

## One-command install

From this repo directory:

```bash
bash ./scripts/bootstrap.sh
```

What it does:

1. Installs required packages (Neovim, git, curl, compiler tools, ripgrep/fd, tree-sitter CLI)
2. Backs up existing `~/.config/nvim` (if different)
3. Copies this config into `~/.config/nvim`
4. Installs plugins (`:Lazy sync` headless)
5. Installs Treesitter parsers for `c` + `cpp`
6. Installs JetBrainsMono Nerd Font (optional step, auto-attempted)

## After install

Open Neovim:

```bash
nvim
```

Then run (once):

```vim
:Mason
:checkhealth
```

Install or verify these Mason tools:

- `clangd`
- `clang-format`
- `lua-language-server`
- `typescript-language-server`
- `pyright`
- `bash-language-server`
- `marksman`
- `stylua`
- `codelldb`

## Daily usage

- **Find files:** `<leader>ff`
- **Live grep:** `<leader>fw`
- **Toggle tree:** `<leader>e`
- **Format:** `<leader>fm`
- **Lazygit:** `<leader>gg`
- **Theme switcher:** `<leader>th`

## Theme / syntax customization

Color roles are centralized in:

- `lua/config/theme.lua`

To change defaults, edit `vim.theme.syntax` values (for example `func_call`, `type`, `parameter`, `operator`), then restart Neovim.

## Troubleshooting

### Treesitter parser missing

Run:

```vim
:TSInstall c cpp
:TSUpdate
```

If parser install still fails, ensure these are on `PATH`:

- `tree-sitter`
- `curl`
- `tar`
- C compiler (`gcc` or `clang`)

### LSP command missing (like `:LspRestart`)

Open a normal file buffer first so `nvim-lspconfig` loads, then retry.

### Reset plugin state

```vim
:Lazy sync
:TSUpdate
:checkhealth
```

## Repo layout

```text
.
├── init.lua
├── lua/
│   ├── chadrc.lua
│   ├── options.lua
│   ├── mappings.lua
│   ├── autocmds.lua
│   ├── config/
│   │   ├── theme.lua
│   │   ├── format.lua
│   │   └── ts_compat.lua
│   ├── configs/
│   │   ├── lazy.lua
│   │   ├── conform.lua
│   │   └── lspconfig.lua
│   └── plugins/
│       ├── init.lua
│       ├── treesitter.lua
│       ├── telescope.lua
│       └── ...
├── scripts/
│   ├── bootstrap.sh
│   └── install_jetbrains_mono_nerd.sh
└── queries/
    └── c/highlights.scm
```

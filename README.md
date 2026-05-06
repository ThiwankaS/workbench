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

## Keybinding help (important)

You can always discover bindings live with **Which Key**:

- press `<leader>` and pause

Detailed bindings in this config:

### Navigation / files

- `<leader>ff` → find files
- `<leader>fw` → live grep
- `<leader>fb` → buffers
- `<leader>fo` → old files
- `<leader>e` → focus tree
- `<C-n>` → toggle tree window

### Editing

- `<leader>fm` → format current buffer
- `<leader>/` (normal/visual) → toggle comment
- `<Esc>` → clear search highlight
- `<C-s>` → save file

### Buffers / windows / terminal

- `<tab>` / `<S-tab>` → next / previous buffer
- `<leader>x` → close buffer
- `<C-h> <C-j> <C-k> <C-l>` → move across windows
- `<leader>h` → horizontal terminal
- `<leader>v` → vertical terminal

### Git / tools

- `<leader>gg` → lazygit
- `<leader>gf` → lazygit current file
- `<leader>gl` → lazygit log
- `<leader>go` → open repo URL

### LSP / diagnostics

- `gd` / `gD` → definition / declaration
- `<leader>D` → type definition
- `<leader>ra` → rename
- `<leader>ds` → diagnostics list

### UI / themes

- `<leader>th` → theme switcher
- `<leader>ch` → NvChad cheatsheet

## DAP debugging (C/C++/Rust)

This config uses:

- `mfussenegger/nvim-dap`
- `jay-babu/mason-nvim-dap.nvim`
- `rcarriga/nvim-dap-ui`
- adapter: `codelldb` (auto-installed through Mason DAP integration)

Debug keybindings:

- `<leader>db` → toggle breakpoint
- `<leader>dB` → conditional breakpoint
- `<leader>dc` → continue / start
- `<leader>dC` → terminate
- `<leader>do` → step over
- `<leader>di` → step into
- `<leader>dO` → step out
- `<leader>dl` → run last config
- `<leader>du` → toggle DAP UI

Launch configs included in `lua/plugins/dap.lua`:

- **Launch file (prompt for binary)**: asks for executable path and optional args
- **Attach to PID**: asks for process id and attaches debugger

Filetypes wired to these configs:

- `cpp`
- `c`
- `rust`

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

### C++ member completion not showing (class methods from `.hpp`)

`clangd` needs project compile flags to index headers reliably.

For CMake projects, generate a compile database:

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json ./compile_commands.json
```

Then restart Neovim and reopen the C++ file.

Manual trigger for completion popup:

- `<C-Space>`

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

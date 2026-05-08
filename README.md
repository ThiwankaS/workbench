# Neovim Config (NvChad + Lazy.nvim)

Custom Neovim setup based on **NvChad v2.5** with Lazy.nvim, LSP, Treesitter, formatting, DAP, and C/C++ friendly defaults.

- **Leader key:** `Space`
- **Theme:** set in `lua/chadrc.lua` (`base46.theme`) — `<leader>th` opens the theme picker
- **Status line:** clock on the right (`lua/chadrc.lua` → `ui.statusline.modules.clock`)
- **Main config root:** `~/.config/nvim`

### Two installers (do not confuse them)

| What | Command | Installs |
|------|---------|----------|
| **Neovim plugins** (blink.cmp, Telescope, NvChad, …) | `:Lazy` / `:Lazy sync` | Lua plugins under `stdpath('data')/lazy/` |
| **CLI tools** (clangd, stylua, pyright, …) | `:Mason` → move to a package, press **`i`** | Language servers & formatters on your system |

Mason’s “Installed (0)” only means **no Mason packages yet** — it does **not** mean Lazy plugins are missing.

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

## Completion & snippets (blink.cmp + LuaSnip)

- **Engine:** [blink.cmp](https://github.com/Saghen/blink.cmp) — NvChad’s **nvim-cmp is disabled** (`lua/plugins/init.lua`).
- **Snippets:** LuaSnip + friendly-snippets (`lua/plugins/blink.lua`, loads `nvchad.configs.luasnip`).
- **LSP capabilities:** `lua/configs/lspconfig.lua` merges `blink.cmp` with NvChad’s client capabilities.

**Insert mode — completion menu**

| Key | Action |
|-----|--------|
| **Enter** | Accept (**select_and_accept**: picks highlighted item or first item) |
| **Tab** | Next item in menu; otherwise LuaSnip snippet jump forward |
| **Shift+Tab** | Previous item; otherwise LuaSnip jump backward |
| **Ctrl+Space** | Open menu / docs (blink default “enter” preset extras) |
| **Ctrl+E** | Close menu |

First completion row is **preselected** so Enter works immediately. More detail: `:h blink-cmp-config-keymap`.

**Brackets / quotes while typing** — [nvim-autopairs](https://github.com/windwp/nvim-autopairs) in `lua/plugins/autopairs.lua` (required after switching off NvChad’s `nvim-cmp`, which used to load autopairs). Typing `[`, `(`, `"`, etc. closes the pair automatically. Blink’s **auto_brackets** only adds parens when **accepting** some LSP completions, not for raw typing.

## Fuzzy finding (Telescope + fzf-native)

`lua/plugins/telescope.lua` loads **telescope-fzf-native** for faster fuzzy sorting. First install may run **`make`** (needs `make` + a C compiler).

## Daily usage

- **Find files:** `<leader>ff`
- **Live grep:** `<leader>fg`
- **Toggle tree:** `<leader>e`
- **Format:** `<leader>fm`
- **Lazygit:** `<leader>gg`
- **Theme switcher:** `<leader>th`

## Keybinding help (important)

You can always discover bindings live with **Which Key**:

- press `<leader>` and pause

Detailed bindings in this config:

### Motion & cursor (line, word, file)

These are standard **Vim/Neovim** motions; this config does not override them in Normal mode.

**Character / line**

| Action | Keys |
|--------|------|
| Left / down / up / right | `h` `j` `k` `l` |
| Half-page up / down | `<C-u>` / `<C-d>` |
| Previous / next paragraph | `{` / `}` |

**Start / end of line**

| Action | Keys |
|--------|------|
| Column 0 | `0` |
| First non-blank on line | `^` |
| End of line | `$` |

**Insert mode** (NvChad extras): `<C-b>` beginning of line, `<C-e>` end of line, `<C-h>` left.  
Note: in this config, **`<C-l>` in Insert mode** is mapped to **lowercase word** (`lua/mappings.lua`), not “cursor right”—use **arrow keys** or exit Insert and use `l`.

**Word by word**

| Action | Keys |
|--------|------|
| Next word / WORD | `w` / `W` |
| End of word / WORD | `e` / `E` |
| Back word / WORD | `b` / `B` |

**File**

| Action | Keys |
|--------|------|
| First line | `gg` |
| Last line | `G` |
| Go to line N | `NG` or `:N` then Enter |

### Navigation / files

- `<leader>ff` → find files
- `<leader>fg` → live grep
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
│       ├── blink.lua
│       ├── autopairs.lua
│       ├── treesitter.lua
│       ├── telescope.lua
│       └── ...
├── scripts/
│   ├── bootstrap.sh
│   └── install_jetbrains_mono_nerd.sh
└── queries/
    └── c/highlights.scm
```

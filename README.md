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
- **Format:** `<leader>cf` (Conform; LSP fallback)
- **Code snapshot:** `<leader>ss` (snap.nvim)
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
- `<leader>fo` / `<leader>fr` → old / recent files
- `<leader>e` → toggle file tree
- `<leader>ef` → reveal file in tree

### Editing

- `<leader>cf` → format buffer (Conform + LSP fallback)
- `<leader>gq` → format via LSP only
- `<leader>ss` / `<leader>sS` → code snapshot (image / HTML)
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
- `<leader>df` → diagnostic messages at cursor (floating)
- `[d` / `]d` → jump to previous / next diagnostic

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

### LSP restart

Neovim 0.11+:

```vim
:lsp restart
```

Restart only clangd:

```vim
:lsp restart clangd
```

If `:lsp restart` is not available, quit and reopen Neovim. Open a real file buffer first so LSP has started.

### C++ member completion not showing (class methods from `.hpp`)

`clangd` needs project compile flags to index headers reliably.

For CMake projects, generate a compile database:

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json ./compile_commands.json
```

Then restart Neovim and reopen the C++ file.

### ESP-IDF / FreeRTOS (clangd)

clangd uses your **host** compiler by default. ESP-IDF uses a **cross** `gcc`/`g++` with flags like `-mlongcalls`, so without the right setup you see “Unknown argument”, missing `machine/endian.h`, and bogus types (`std::string` as `int`).

Do this **in each IDF project** (or once via `direnv`):

1. **Load the IDF environment** (so `idf.py` and the toolchain exist):

   ```bash
   . $IDF_PATH/export.sh   # or your install’s export script
   ```

2. **Configure and build** (generates `build/compile_commands.json`):

   ```bash
   cd /path/to/your_project   # e.g. telemetry_node
   idf.py set-target esp32s3   # or esp32, esp32c3, …
   idf.py build
   ```

3. **Point clangd at the compile database** from the project root (same directory as top-level `CMakeLists.txt`):

   ```bash
   ln -sf build/compile_commands.json ./compile_commands.json
   ```

   If you prefer not to symlink, add a **`.clangd`** file in the project root:

   ```yaml
   CompileFlags:
     CompilationDatabase: build
   ```

4. **Allow clangd to query the Xtensa/RISC-V toolchain** (fixes “Unknown argument …” for IDF flags). Set a **comma-separated** glob list (no spaces after commas). Example for a typical Espressif tool install under `$HOME/.espressif`:

   ```bash
   export CLANGD_QUERY_DRIVER="$HOME/.espressif/tools/**/bin/*-gcc,$HOME/.espressif/tools/**/bin/*-g++"
   ```

   Put that in `~/.bashrc`, a project `.envrc` (direnv), or run it in the same terminal before `nvim`. This Neovim config reads **`CLANGD_QUERY_DRIVER`** and passes it to clangd as `--query-driver=…`.

5. **Restart clangd** after changes: `:lsp restart clangd` or restart Neovim.

6. **Optional:** If `compile_commands.json` is missing entries for a component, run a full build again; IDF’s CMake should regenerate it.

Manual trigger for completion popup:

- `<C-Space>`

### Code snapshots (snap.nvim)

Snapshots use the **active colorscheme** (Gruvbox + Treesitter/LSP) and **JetBrainsMono Nerd Font**.

| Key | Action |
|-----|--------|
| `<leader>ss` | Snapshot selection or full buffer → clipboard + `~/Pictures/Screenshots` |
| `<leader>sS` | Snapshot as HTML |

**First-time setup** (backend ~127 MB, includes Chromium + `playwright-core`):

```bash
~/.config/nvim/scripts/install_snap_backend.sh
```

Or in Neovim: `:SnapInstall`. If export fails with `playwright-core` errors, re-run the script (install must include `bin/node_modules/`, not only `snap-nvim` + `playwright/`).

Optional font tuning in `init.lua`:

```lua
vim.g.snap_font_size = 14
vim.g.snap_font_line_height = 1.0
```

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
│   │   ├── snap.lua
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
│       ├── snap.lua
│       └── ...
├── scripts/
│   ├── bootstrap.sh
│   ├── install_jetbrains_mono_nerd.sh
│   └── install_snap_backend.sh
└── queries/
    └── c/highlights.scm
```

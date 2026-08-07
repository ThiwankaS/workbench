# CoreForge Workbench

Minimal **Neovim 0.12** config using **[vim.pack](https://neovim.io/doc/user/pack.html)** and **[NvUI](https://nvchad.com/news/nvui/)** (NvChad UI + Base46).

Focus: **C**, **C++**, **JavaScript**, **Python** — Treesitter, Telescope, nvim-tree, Mason LSP, NvChad statusline + tabufline.

## Documentation

- **Web guide:** https://thiwankas.github.io/workbench/
- **Local guide:** `xdg-open ~/.config/nvim/workbench.html`
- **NvUI docs:** `:h nvui` (after first launch)

## Requirements

- Neovim **≥ 0.12** (with `vim.pack`)
- `git`, `ripgrep` (for live grep), `gcc` / `clang` (for Treesitter parsers)

## Quick start (Debian 13)

```bash
git clone https://github.com/ThiwankaS/workbench.git ~/.config/nvim
cd ~/.config/nvim
bash ./scripts/bootstrap.sh
nvim
```

On first launch, `vim.pack` installs plugins and Base46 compiles theme highlights.

```vim
:checkhealth vim.pack
:Mason
:MasonInstallAll
:TSInstall c cpp javascript python
```

Set your **terminal font** to `JetBrainsMono Nerd Font` (required for icons).

## Layout

```
~/.config/nvim/
├── init.lua                 vim.pack.add + NvUI bootstrap
├── nvim-pack-lock.json      plugin lockfile (commit this)
├── workbench.html           full reference guide
├── lua/
│   ├── chadrc.lua           NvUI / Base46 options (theme, statusline, tabufline)
│   ├── core/
│   │   ├── options.lua      editor defaults + diagnostics
│   │   ├── keymaps.lua      leader maps + LSP
│   │   ├── maputil.lua      guard helpers for plugin buffers
│   │   └── font.lua         GUI font
│   └── setup/
│       ├── nvui.lua         Base46 cache + require("nvchad")
│       ├── clock.lua        digital clock + date (statusline)
│       ├── gitsigns.lua
│       ├── treesitter.lua
│       ├── tree.lua         nvim-tree
│       ├── telescope.lua
│       ├── autopairs.lua
│       ├── lsp.lua          clangd, ts_ls, pyright
│       ├── explore.lua      outline, call graph pickers, Obsidian notes
│       └── cmp.lua
└── scripts/
    ├── bootstrap.sh
    └── install_jetbrains_mono_nerd.sh
```

## Keymaps

Tuned for a **65% keyboard** — home-row `Space` chords, no `[` `]` keys.

| Keys | Action |
|------|--------|
| `Space th` | Theme picker (68 Base46 themes) |
| `Space tt` | Toggle theme pair (`chadrc.lua`) |
| `Space e` | Toggle file tree |
| `Space j` | Reveal file in tree |
| `Space f` | Find files |
| `Space g` | Live grep |
| `Space p` | Pick buffer |
| `Space o` | Recent files |
| `gb` | Toggle last two buffers |
| `Space h` / `Space l` | Previous / next buffer |
| `Space w` | Save (normal mode) |
| `Ctrl+s` | Save (insert mode) |
| `Space q` | Quit |
| `Space x` | Close buffer |
| `Ctrl+h/j/k/l` | Move between windows |
| `Alt+j` / `Alt+k` | Move line down / up (normal + visual) |
| `Alt+e` | Jump past closing bracket/quote |
| `Space k` | Hover (LSP) |
| `Space n` | Rename (LSP) |
| `Space a` | Code action (LSP) |
| `Space m` | Format (LSP) |
| `Space dd` | Diagnostic message at cursor |
| `Space dk` / `Space dj` | Prev / next diagnostic |
| `gd` / `gr` / `gi` / `gt` | Definition / references / implementation / type |
| `Space u` | Toggle symbol outline (Aerial) |
| `Space ss` / `Space sw` | Symbols in file / project |
| `Space si` / `Space so` | Incoming / outgoing calls |
| `Space sn` | Architecture note for word under cursor (needs vault) |
| `Enter` or `Ctrl+y` | Confirm completion |
| `Ctrl+n` / `Ctrl+p` | Next / prev completion item (or open menu) |
| `Ctrl+u` / `Ctrl+l` | Uppercase / lowercase word (insert) |

Diagnostic text also appears inline at the end of each problem line.

## Exploring a codebase (~2.5k LOC)

**One-time setup**

1. Restart Neovim so new plugins load (first launch may run `:lua vim.pack.update()` automatically).
2. Open your project root (`nvim .` or `cd` into the repo first).
3. For **C/C++**, generate `compile_commands.json` so clangd knows includes and call hierarchy works:
   ```bash
   cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
   cmake --build build
   ln -sf build/compile_commands.json .
   ```
4. **Optional — Obsidian / markdown notes:** point at a vault folder (can be `your-repo/docs`):
   ```bash
   export OBSIDIAN_VAULT="$HOME/path/to/vault"
   ```
   Or uncomment and set `vim.g.obsidian_vault` in `init.lua`.

**Daily workflow**

| Step | Keys | What you get |
|------|------|----------------|
| File map | `Space u` | Symbol outline sidebar (classes, functions) |
| Jump in file | `Space ss` | Pick class/function in current file |
| Jump in project | `Space sw` | Search symbols across the repo |
| Who calls this? | `Space si` | Incoming call hierarchy (needs LSP) |
| What does this call? | `Space so` | Outgoing call hierarchy |
| Go to definition | `gd` | Jump to implementation |
| All references | `gr` | Every use of symbol |
| Implementation | `gi` | Override / concrete impl |
| Type | `gt` | Type definition |
| Architecture note | `Space sn` | Create/open `notes/Symbol.md` in vault (Mermaid stub) |

Use **`Space si`** / **`Space so`** on a function name, then fill **`Space sn`** notes with what you learned. Open the same vault in **Obsidian** for graph view and class diagrams in Mermaid blocks.

Markdown notes render in Neovim (headings, fenced code). Follow `[[wiki links]]` with **`gf`** when Obsidian.nvim is enabled.

## Plugin management

```vim
:lua vim.pack.update()
:lua vim.pack.update(nil, { force = true })
:checkhealth vim.pack
```

## LSP servers (via Mason)

| Language | Server |
|----------|--------|
| C / C++ | clangd |
| JavaScript / TypeScript | typescript-language-server (`ts_ls`) |
| Python | pyright |

C/C++ needs `compile_commands.json` in the project root for full clangd support.

Run `:MasonInstallAll` to install servers declared in `lua/setup/lsp.lua`.

## Theme & UI

[NvUI](https://github.com/NvChad/ui) + [Base46](https://github.com/NvChad/base46) replace the old custom bufferline / lualine / theme stack:

- **68 themes** — `Space th` opens the Volt theme picker (`:h nvui.theme-picker`)
- **Quick toggle** — `Space tt` switches between themes in `theme_toggle` inside `lua/chadrc.lua`
- **Statusline + tabufline** — configured in `chadrc.lua` under `ui.statusline` and `ui.tabufline`
- **Digital clock** — `lua/setup/clock.lua` shows live `HH:MM:SS` + date on the statusline (right side)
- **Transparency** — `base46.transparency = true` in `chadrc.lua` (works with Ghostty `background-opacity`)

Edit `lua/chadrc.lua` to change the default theme, statusline style, or transparency.

Persistent undo is stored in `~/.config/nvim/undodir/` (gitignored).

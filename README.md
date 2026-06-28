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
│   │   ├── options.lua      editor defaults
│   │   ├── keymaps.lua      leader maps + LSP
│   │   └── font.lua         GUI font
│   └── setup/
│       ├── nvui.lua         Base46 cache + require("nvchad")
│       ├── gitsigns.lua
│       ├── treesitter.lua
│       ├── tree.lua         nvim-tree
│       ├── telescope.lua
│       ├── lsp.lua          clangd, ts_ls, pyright
│       └── cmp.lua
└── scripts/
    ├── bootstrap.sh
    └── install_jetbrains_mono_nerd.sh
```

## Keymaps

Tuned for a **65% keyboard** — home-row chords, no `[` `]` keys, `Ctrl+h/j/k/l` for windows.

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
| `Space w` or `Ctrl+s` | Save |
| `Space q` | Quit |
| `Space x` | Close buffer |
| `Ctrl` or `Alt` `h/j/k/l` | Move between windows |
| Arrow keys | Move between windows (Fn layer) |
| `Space k` | Hover (LSP) |
| `Space n` | Rename (LSP) |
| `Space a` | Code action (LSP) |
| `Space m` | Format (LSP) |
| `Space dh` / `Space dl` | Prev / next diagnostic |
| `Space df` | Diagnostic float |
| `gd` / `gr` | Definition / references |
| `Ctrl+n` / `Ctrl+p` | Completion next / prev (insert) |
| `Ctrl+u` / `Ctrl+l` | Uppercase / lowercase word (insert) |

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
- **Transparency** — `base46.transparency = true` in `chadrc.lua` (works with Ghostty `background-opacity`)

Edit `lua/chadrc.lua` to change the default theme, statusline style, or transparency.

Persistent undo is stored in `~/.config/nvim/undodir/` (gitignored).

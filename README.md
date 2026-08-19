# CoreForge Workbench

Minimal **Neovim 0.12** config using **[vim.pack](https://neovim.io/doc/user/pack.html)** and **[NvUI](https://nvchad.com/news/nvui/)** (NvChad UI + Base46).

Focus: **C**, **C++**, **JavaScript**, **Python** — Treesitter, Telescope, nvim-tree, Mason LSP, code exploration, markdown preview.

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
├── init.lua                 Load order: options → plugins → setup → keymaps
├── lua/
│   ├── config.lua           ★ User settings (vault, preview types, LSP list)
│   ├── chadrc.lua           NvUI theme, statusline, tabufline
│   ├── core/
│   │   ├── options.lua      Editor defaults + diagnostics (single source)
│   │   ├── keymaps.lua      Global leader maps (one binding per feature)
│   │   ├── maputil.lua      Skip maps in tree / Telescope / Mason buffers
│   │   ├── filetypes.lua    Shared filetype lists (ui_plugin, lsp_skip)
│   │   └── font.lua         GUI font
│   └── setup/
│       ├── nvui.lua         Base46 cache + NvChad
│       ├── clock.lua        Statusline clock
│       ├── treesitter.lua
│       ├── tree.lua         nvim-tree
│       ├── telescope.lua
│       ├── explore.lua      Aerial, render-markdown, Obsidian
│       ├── markdown_preview.lua  Browser preview (Mermaid, PlantUML)
│       ├── lsp.lua          Mason, servers, buffer LSP maps
│       ├── cmp.lua          Completion keys
│       ├── autopairs.lua
│       └── gitsigns.lua
├── workbench.html           Full reference guide
├── nvim-pack-lock.json      Plugin lockfile (commit this)
└── scripts/
    ├── bootstrap.sh
    └── install_jetbrains_mono_nerd.sh
```

### Load order (`init.lua`)

1. `config.lua` → paths (`obsidian_vault`, etc.)
2. `core/options.lua` — editor + diagnostics
3. `setup/markdown_preview.configure()` — `vim.g.mkdp_*` before plugin loads
4. `vim.pack.add` — plugins
5. `setup/*.setup()` — plugin configuration
6. `core/keymaps.lua` — global maps last (won't be overridden)

### User settings (`lua/config.lua`)

Edit this file for paths and toggles. Restart Neovim after changes.

| Setting | Purpose |
|---------|---------|
| `obsidian_vault` | Folder for `Space sn` architecture notes (`nil` disables Obsidian) |
| `preview_filetypes` | Filetypes for `Space mp` browser preview |
| `lsp_servers` | Mason packages auto-installed on first run |

## Keymaps

Tuned for a **65% keyboard** — home-row `Space` chords, no `[` `]` keys.

| Keys | Action |
|------|--------|
| `Space th` | Theme picker (68 Base46 themes) |
| `Space tt` | Toggle theme pair (`gruvbox` ↔ `onedark`) |
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
| `Alt+e` | Jump past closing bracket/quote (insert) |
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
| `Space mp` | Browser preview (.md / .puml) |
| `Enter` or `Ctrl+y` | Confirm completion |
| `Ctrl+n` / `Ctrl+p` | Next / prev completion item (or open menu) |
| `Ctrl+u` / `Ctrl+l` | Uppercase / lowercase word (insert) |

Diagnostic text appears inline at the end of each problem line and in a float (`Space dd`).

LSP buffer maps live in `lua/setup/lsp.lua`. Global maps live in `lua/core/keymaps.lua`. Completion keys live only in `lua/setup/cmp.lua`.

## Exploring a codebase (~2.5k LOC)

**One-time setup**

1. Open your project root (`nvim .`).
2. For **C/C++**, generate `compile_commands.json`:
   ```bash
   cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
   cmake --build build
   ln -sf build/compile_commands.json .
   ```
3. **Optional — Obsidian notes:** edit `obsidian_vault` in `lua/config.lua`, or:
   ```bash
   export OBSIDIAN_VAULT="$HOME/path/to/vault"
   ```

**Daily workflow**

| Step | Keys | What you get |
|------|------|----------------|
| File map | `Space u` | Symbol outline sidebar |
| Jump in file | `Space ss` | Pick symbol in current file |
| Jump in project | `Space sw` | Search symbols across repo |
| Who calls this? | `Space si` | Incoming call hierarchy |
| What does this call? | `Space so` | Outgoing call hierarchy |
| Go to definition | `gd` | Jump to implementation |
| All references | `gr` | Every use of symbol |
| Architecture note | `Space sn` | Create/open `notes/Symbol.md` in vault |
| Preview diagrams | `Space mp` | Live markdown + Mermaid in browser |

Markdown renders in-editor (render-markdown). Follow `[[wiki links]]` with **`gf`** when Obsidian is enabled.

## Browser preview

Works on `.md` and `.puml` files configured in `lua/config.lua`.

1. First time: `:MarkdownPreviewInstall`
2. Open a markdown or PlantUML buffer
3. Press **`Space mp`** to toggle browser preview

**Mermaid** — fenced blocks in `.md`. **PlantUML** — `.puml` file or fenced block; must end with `@enduml`. PlantUML uses plantuml.com (needs internet).

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
| Dockerfile | dockerls (`dockerfile-language-server`) |

Server list is in `lua/config.lua` (`lsp_servers`). C/C++ needs `compile_commands.json` for full clangd support.

## Theme & UI

- **68 themes** — `Space th` (Volt theme picker)
- **Quick toggle** — `Space tt` switches `gruvbox` ↔ `onedark` (`lua/chadrc.lua`)
- **Statusline + tabufline** — `lua/chadrc.lua`
- **Digital clock** — live time + date on statusline
- **Git signs** — change markers in gutter (gitsigns.nvim)

Persistent undo: `~/.config/nvim/undodir/` (gitignored).

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Plugins missing | `:lua vim.pack.update()` · `:checkhealth vim.pack` |
| clangd crash / no diagnostics | `:LspRestart` · add `compile_commands.json` |
| Live grep empty | `sudo apt install ripgrep` |
| Alt+j/k dead | Enable option-as-meta in terminal |
| Preview fails | Open `.md`/`.puml` first · `:MarkdownPreviewInstall` · `Space mp` |

See `workbench.html` for the full guide.

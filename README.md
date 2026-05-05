# Neovim Config (Locked + VS Code Friendly)

This setup is optimized for daily coding with fast navigation, strong LSP support, and predictable behavior.

- Leader key: `Space`
- Start in project root: `nvim .`
- Color scheme: Catppuccin
- Plugin manager: Lazy.nvim (pinned by `lazy-lock.json`)

## Stability First (Locked Setup)

Your setup is locked so random updates do not break it:

- Plugin commits are pinned in `lazy-lock.json`.
- Automatic background update checks are disabled in `lua/config/lazy.lua`.
- Luarocks integration is disabled to reduce moving parts.

Recommended update workflow:

1. Make a backup branch or copy of this config.
2. Run `:Lazy sync` manually only when you choose to update.
3. Test with `:checkhealth` and open your usual projects.
4. If needed, revert lockfile or plugin changes.

## Directory Structure

```text
~/.config/nvim
├── init.lua
├── README.md
├── lazy-lock.json
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins
│       ├── coding.lua
│       ├── godbolt.lua
│       ├── lsp.lua
│       ├── markdown.lua
│       ├── multicursor.lua
│       ├── snacks.lua
│       ├── telescope.lua
│       ├── theme.lua
│       ├── tmux.lua
│       ├── tree.lua
│       ├── treesitter.lua
│       └── ui.lua
└── .gitignore
```

## Productivity Playbook

Use these habits for maximum speed:

- Open projects with `nvim .`.
- Use Telescope first (`<leader>ff`, `<leader>fg`) before browsing tree.
- Keep both tree and split navigation in muscle memory (`<leader>e`, `Ctrl+h/j/k/l`).
- Use multi-cursor for repeated edits and comments for fast refactors.
- Use LSP actions early (`gd`, `gr`, `<leader>rn`, `<leader>ca`) to avoid manual edits.
- Keep git flow inside Neovim via Lazygit (`<leader>gg`).

## Keybindings Cheat Sheet

### Command and Search

- `<leader><leader>` open plain command line (`:`)
- `<leader>ff` find file
- `<leader>fg` live grep in project
- `<leader>fr` recent files
- `<leader>fb` open buffers
- `<leader>fc` Telescope command list
- `<leader>:` command history

### Explorer

- `<leader>e` toggle file tree
- `<leader>ef` reveal current file in tree
- In tree: `l` open, `h` close parent, `H` collapse all, `a` add, `d` delete, `r` rename, `v` vertical split

### Editing

- `gcc` comment line
- `gc` comment visual selection
- `Alt+j` / `Alt+k` move line or selection
- `<Esc>` clear search highlights
- `<C-a>` select all
- Insert mode: `<C-u>` uppercase word, `<C-l>` lowercase word
- Visual mode: `<` and `>` reindent and reselect

### Buffers / Windows / Tmux

- `L` next buffer
- `H` previous buffer
- `<leader>x` close buffer
- `<leader>cd` set cwd to current file directory
- `Ctrl+w,v` vertical split
- `Ctrl+h/j/k/l` navigate splits and tmux panes

### LSP / Completion

- `gd` go to definition
- `gr` references
- `K` hover
- `<leader>rn` rename symbol
- `<leader>ca` code action
- Completion: `Tab` next, `Shift+Tab` previous, `Enter` confirm

### Git / Markdown / Tools

- `<leader>gg` Lazygit root
- `<leader>gf` current file git history
- `<leader>gl` project log
- `<leader>go` open remote repo in browser
- `<leader>mp` markdown preview
- `:Godbolt`, `:GodboltCompiler`, `:GodboltRun` for compiler explorer

## Learn One Plugin at a Time

This section groups bindings by plugin/module so you can practice one area per day.

### `telescope.nvim` (`lua/plugins/telescope.lua`)

- `<leader>ff` find files
- `<leader>fg` live grep
- `<leader>fr` recent files
- `<leader>fb` open buffers
- `<leader>fc` command list (Telescope picker)
- `<leader>:` command history (Telescope picker)
- `<leader>cd` set cwd to current file directory

### `nvim-tree.lua` (`lua/plugins/tree.lua`)

- `<leader>e` toggle file explorer
- `<leader>ef` reveal current file in tree
- Inside tree:
  - `l` open node
  - `h` close parent
  - `H` collapse all
  - `a` add file/folder
  - `d` delete
  - `r` rename
  - `v` open vertical split

### `nvim-lspconfig` + `mason` + `nvim-cmp` (`lua/plugins/lsp.lua`)

- `gd` go to definition
- `gr` list references
- `K` hover docs
- `<leader>rn` rename symbol
- `<leader>ca` code action
- Insert mode completion:
  - `Tab` next suggestion
  - `Shift+Tab` previous suggestion
  - `Enter` confirm suggestion
  - `Ctrl+Space` open completion menu
- Useful commands:
  - `:Mason` open LSP/tool installer

### `Comment.nvim` + `mini.move` (`lua/plugins/coding.lua`)

- `gcc` toggle line comment
- `gc` toggle selection comment (visual mode)
- `Alt+j` / `Alt+k` move line or selection up/down

### `vim-visual-multi` (`lua/plugins/multicursor.lua`)

- `Ctrl+d` add next match as cursor
- `<leader>va` select all matches

### `vim-tmux-navigator` (`lua/plugins/tmux.lua`)

- `Ctrl+h` move left split/tmux pane
- `Ctrl+j` move down split/tmux pane
- `Ctrl+k` move up split/tmux pane
- `Ctrl+l` move right split/tmux pane

### `lazygit.nvim` (`lua/plugins/snacks.lua` + keymaps)

- `<leader>gg` open Lazygit
- `<leader>gf` current file history/view
- `<leader>gl` project git log
- `<leader>go` open repo remote URL in browser

### `mark.nvim` (`lua/plugins/markdown.lua`)

- `<leader>mp` toggle markdown preview panel

### `godbolt.nvim` (`lua/plugins/godbolt.lua`)

- Commands (run with `:`):
  - `:Godbolt` open Godbolt buffer/action
  - `:GodboltCompiler` choose compiler/options
  - `:GodboltRun` compile/run current snippet
  - `:GodboltOpen` open current code in browser

### `which-key.nvim` (`lua/plugins/ui.lua`)

- Press `<leader>` and pause to see available leader key groups.

### `catppuccin` (`lua/plugins/theme.lua`)

- No keybindings (theme plugin). Automatically applied on startup.

### `snacks.nvim` (`lua/plugins/snacks.lua`)

- No direct custom keybindings configured in this setup.
- Provides dashboard, notifier, smooth scroll, picker helpers, and big-file support.

## First-time Setup

1. Open Neovim: `nvim`
2. Run `:Lazy sync`
3. Run `:Mason` and ensure needed LSP servers are installed (for C++ use `clangd`)
4. Run `:TSUpdate`
5. Run `:checkhealth`

## Common Recovery Commands

- Reinstall plugins: `:Lazy sync`
- Rebuild parsers: `:TSUpdate`
- Re-run diagnostics: `:checkhealth`
- Clear stale data only if needed:
  - remove one broken plugin from `~/.local/share/nvim/lazy/<plugin-name>`
  - run `:Lazy sync` again

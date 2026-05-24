# Neovim Cheat Sheet

Leader key: `Space`
Theme: `Gruvbox` (`lua/chadrc.lua`; switch with `<leader>th`)

## Navigation

- `<leader>ff` Find files
- `<leader>fg` Search text in project
- `<leader>fr` Recent files
- `<leader>fb` Open buffers
- `<leader>cd` Set cwd to current file folder

## File Tree

- `<leader>e` Toggle tree
- `<leader>ef` Reveal current file in tree
- `l` or `Enter` Open node
- `h` Close folder / go to parent
- `H` Collapse all folders
- `a` Add file/folder
- `d` Delete
- `r` Rename
- `v` Open vertical split

## Tabs and Windows

- `L` Next buffer
- `H` Previous buffer
- `<leader>x` Close current buffer
- `Ctrl+w,v` Split vertical
- `Ctrl+h/j/k/l` Move between splits/tmux panes

## Code snapshots

- `<leader>ss` Snapshot (image → clipboard + `~/Pictures/Screenshots`)
- `<leader>sS` Snapshot as HTML
- `:SnapInstall` or `scripts/install_snap_backend.sh` — first-time backend (~127 MB)

## Coding

- `gcc` Toggle line comment
- `gc` Toggle selection comment (visual mode)
- `Alt+j` Move line/selection down
- `Alt+k` Move line/selection up
- `Tab` Next completion item
- `Shift+Tab` Previous completion item
- `Enter` Confirm completion
- `<Esc>` Clear search highlight

## C++ Ready

- `clangd` installed via Mason/LSP (`:Mason`)
- Treesitter parsers include `c` and `cpp`
- Comment support ready for C++ (`//` and block comments) via `Comment.nvim`
- Pair insertion enabled via `nvim-autopairs`
- Godbolt integration available (`:Godbolt`, `:GodboltCompiler`, `:GodboltRun`)

## Git and Markdown

- `<leader>gg` Open Lazygit
- `<leader>gf` File git history/status view
- `<leader>gl` Project log
- `<leader>go` Open repo URL in browser
- `<leader>mp` Toggle markdown preview (`mark.nvim`)

## Minimap / outline

- `<leader>mo` / `<leader>mc` Open / close minimap
- `<leader>a` Toggle aerial symbol tree

## Maintenance

- `:Lazy` Plugin manager
- `:Mason` LSP manager
- `:checkhealth` Health diagnostics

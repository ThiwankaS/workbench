-- Convenience alias for keymap API.
local map = vim.keymap.set

-- Clear search highlight quickly.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Close current buffer.
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close current buffer" })
-- Next buffer.
map("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })
-- Previous buffer.
map("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
-- Select all text in current buffer.
map("n", "<C-a>", "ggVG", { desc = "Select all in buffer" })

-- Change working directory to current file directory.
map("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Change CWD to current file" })

-- Split navigation left.
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
-- Split navigation down.
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
-- Split navigation up.
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
-- Split navigation right.
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Uppercase word under cursor from insert mode.
map("i", "<C-u>", "<Esc>gUiwgi", { desc = "Uppercase current word" })
-- Lowercase word under cursor from insert mode.
map("i", "<C-l>", "<Esc>guiwgi", { desc = "Lowercase current word" })

-- Move current line down.
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
-- Move current line up.
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
-- Move visual selection down.
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
-- Move visual selection up.
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
-- Re-indent selection to the left and keep it selected.
map("v", "<", "<gv", { desc = "Indent left and re-select" })
-- Re-indent selection to the right and keep it selected.
map("v", ">", ">gv", { desc = "Indent right and re-select" })

-- Open Lazygit root UI.
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Lazygit (Root)" })
-- Open current file Git history/view.
map("n", "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", { desc = "Lazygit Current File History" })
-- Open project-wide Git log.
map("n", "<leader>gl", "<cmd>LazyGitLog<CR>", { desc = "Lazygit Project Log" })
-- Open remote repository URL in browser.
map("n", "<leader>go", "<cmd>lua vim.ui.open((vim.fn.system('git config --get remote.origin.url'):gsub('%s+$',''):gsub('^git@github.com:','https://github.com/'):gsub('%.git$','')))<CR>", { desc = "Lazygit Open in Browser" })
-- Fast command-line access (VS Code command palette muscle memory).
map("n", "<leader><leader>", ":", { desc = "Command line" })

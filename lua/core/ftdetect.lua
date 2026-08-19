--- Extra filetype rules not covered by Neovim defaults.
vim.filetype.add({
  extension = {
    docker = "dockerfile", -- e.g. ubuntu-noble.docker in .devcontainer/build/
  },
})

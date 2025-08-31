-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Make :terminal spawn your real shell and load login env
vim.opt.shell = "/bin/zsh"

-- Note: termguicolors configured in options.lua

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Better editing experience
opt.relativenumber = true -- Relative line numbers
opt.number = true -- Absolute line number on current line
opt.scrolloff = 8 -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
opt.wrap = false -- Don't wrap lines
opt.breakindent = true -- Wrap indent to match line start
opt.linebreak = true -- Wrap lines at word boundaries

-- Better search
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Override ignorecase if search has uppercase
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show search matches as you type

-- Better splits
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "screen" -- Keep the same relative cursor position

-- Better UI
opt.termguicolors = true -- True color support
opt.signcolumn = "yes" -- Always show sign column
opt.colorcolumn = "120" -- Show column marker at 120 characters
opt.cursorline = true -- Highlight current line
opt.laststatus = 3 -- Global statusline

-- Better editing
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2 -- Number of spaces tabs count for in insert mode
opt.smartindent = true -- Insert indents automatically
opt.shiftround = true -- Round indent to multiple of shiftwidth

-- Better file handling
opt.undofile = true -- Persistent undo
opt.undolevels = 10000 -- Maximum number of changes that can be undone
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.timeoutlen = 300 -- Time to wait for a mapped sequence to complete
opt.backup = false -- Don't backup files
opt.writebackup = false -- Don't backup files

-- Better completion
opt.completeopt = "menu,menuone,noselect" -- Better completion experience
opt.pumheight = 10 -- Maximum number of items in popup menu

-- Performance
opt.lazyredraw = false -- Don't redraw while executing macros
opt.redrawtime = 1500 -- Time in milliseconds for redrawing

-- Fold settings
opt.foldmethod = "expr" -- Use treesitter for folding
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99 -- Start with all folds open
opt.foldenable = true -- Enable folding

-- Better command line
opt.cmdheight = 1 -- More space for displaying messages
opt.showcmd = false -- Don't show command in bottom bar
opt.showmode = false -- Don't show mode since we have a statusline

-- Session options
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Disable some default providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

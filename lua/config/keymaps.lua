-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Intuitive vim-style split navigation and creation
-- Single tap: navigate to split, Double tap: create split in that direction
map("n", "<leader>h", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>j", "<C-w>j", { desc = "Go to lower window" })
map("n", "<leader>k", "<C-w>k", { desc = "Go to upper window" })
map("n", "<leader>l", "<C-w>l", { desc = "Go to right window" })

-- Double tap to create splits
map("n", "<leader>hh", "<C-w>v<C-w>h", { desc = "Split left and focus" })
map("n", "<leader>jj", "<C-w>s", { desc = "Split below and focus" })
map("n", "<leader>kk", "<C-w>s<C-w>k", { desc = "Split above and focus" })
map("n", "<leader>ll", "<C-w>v", { desc = "Split right and focus" })

-- Legacy splits (keep for compatibility)
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- Terminal splits with direct opening
map("n", "<leader>tv", function()
  vim.cmd("vsplit | terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal vertical split" })

map("n", "<leader>th", function()
  vim.cmd("split | terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal horizontal split" })

-- Better terminal navigation
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window from terminal" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window from terminal" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window from terminal" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window from terminal" })
map("t", "<C-n>", "<C-\\><C-n>", { desc = "Normal mode in terminal" })

-- Quick escape from terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })



-- Buffer navigation (muscle memory from other editors)
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Quick save and quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>confirm qa<cr>", { desc = "Quit all" })

-- Center screen after navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Prev search result and center" })

-- Quick file operations
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- Resize windows with arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Quick window actions
map("n", "<leader>wo", "<C-W>o", { desc = "Close other windows", remap = true })
map("n", "<leader>wm", "<C-W>_<C-W>|", { desc = "Maximize window", remap = true })
map("n", "<leader>we", "<C-W>=", { desc = "Equal window sizes", remap = true })

-- Quick access to command mode
map("n", ";", ":", { desc = "Enter command mode" })

-- Improved split and tab management
local map = vim.keymap.set

-- ============ SPLITS ============
-- Simplified split creation (more intuitive)
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equal splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })
map("n", "<leader>so", "<C-w>o", { desc = "Close other splits" })
map("n", "<leader>sm", "<C-w>_<C-w>|", { desc = "Maximize split" })

-- Quick split and open file
map("n", "<leader>sf", function()
  vim.cmd("vsplit")
  require("telescope.builtin").find_files()
end, { desc = "Split and find file" })

-- Better split navigation (keep existing Ctrl+hjkl)
-- Add number prefix to jump to specific window
for i = 1, 9 do
  map("n", "<leader>" .. i, i .. "<C-w>w", { desc = "Go to window " .. i })
end

-- ============ TABS ============
-- Tab creation and navigation
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close other tabs" })
map("n", "<leader>t.", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>t,", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Quick tab switching with numbers
for i = 1, 9 do
  map("n", "<leader>t" .. i, i .. "gt", { desc = "Go to tab " .. i })
end



-- ============ BUFFERS ============
-- Enhanced buffer navigation
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bc", "<cmd>bd<CR>", { desc = "Close buffer" })
map("n", "<leader>bC", "<cmd>bd!<CR>", { desc = "Force close buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Close other buffers" })
map("n", "<leader>ba", "<cmd>bufdo bd<CR>", { desc = "Close all buffers" })

-- Quick buffer switching with numbers
for i = 1, 9 do
  map("n", "<leader>b" .. i, function()
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    if bufs[i] then
      vim.cmd("buffer " .. bufs[i].bufnr)
    end
  end, { desc = "Go to buffer " .. i })
end

-- ============ WORKSPACE LAYOUTS ============
-- Save and restore window layouts
map("n", "<leader>ws", "<cmd>mksession! .session.vim<CR>", { desc = "Save workspace" })
map("n", "<leader>wr", "<cmd>source .session.vim<CR>", { desc = "Restore workspace" })

-- Quick layouts
map("n", "<leader>w2", "<C-w>v", { desc = "2 column layout" })
map("n", "<leader>w3", function()
  vim.cmd("vsplit | vsplit")
  vim.cmd("wincmd =")
end, { desc = "3 column layout" })

map("n", "<leader>wg", function()
  -- Golden ratio layout: main window on left, two stacked on right
  vim.cmd("only")
  vim.cmd("vsplit")
  vim.cmd("wincmd l")
  vim.cmd("split")
  vim.cmd("wincmd h")
  vim.cmd("vertical resize 100")
end, { desc = "Golden ratio layout" })

-- ============ QUICK REFERENCE ============
map("n", "<leader>?s", function()
  local splits = {
    "SPLITS:",
    "  <leader>sv - Split vertical",
    "  <leader>sh - Split horizontal", 
    "  <leader>sx - Close split",
    "  <leader>so - Close others",
    "  <leader>sm - Maximize",
    "  Ctrl+hjkl  - Navigate",
    "",
    "TABS:",
    "  <leader>tn - New tab",
    "  <leader>tc - Close tab",
    "  <leader>t. - Next tab",
    "  <leader>t, - Previous tab",
    "  <leader>t1-9 - Go to tab N",
    "",
    "BUFFERS:",
    "  Tab/S-Tab - Next/Prev buffer",
    "  <leader>bc - Close buffer",
    "  <leader>bo - Close others",
    "  <leader>b1-9 - Go to buffer N",
  }
  vim.notify(table.concat(splits, "\n"), vim.log.levels.INFO, { title = "Split/Tab/Buffer Keys" })
end, { desc = "Show split/tab help" })

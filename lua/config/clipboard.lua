-- Enhanced clipboard configuration for tmux/system integration
local opt = vim.opt
local g = vim.g

-- Use system clipboard by default
opt.clipboard = "unnamedplus"

-- Fix clipboard in tmux/ssh sessions
if vim.env.TMUX then
  -- For macOS in tmux
  if vim.fn.has("mac") == 1 then
    g.clipboard = {
      name = "tmux-osc52",
      copy = {
        ["+"] = {"pbcopy"},
        ["*"] = {"pbcopy"},
      },
      paste = {
        ["+"] = {"pbpaste"},
        ["*"] = {"pbpaste"},
      },
      cache_enabled = true,
    }
  else
    -- For Linux/WSL in tmux
    g.clipboard = {
      name = "tmux-clipboard",
      copy = {
        ["+"] = {"tmux", "load-buffer", "-"},
        ["*"] = {"tmux", "load-buffer", "-"},
      },
      paste = {
        ["+"] = {"tmux", "save-buffer", "-"},
        ["*"] = {"tmux", "save-buffer", "-"},
      },
      cache_enabled = true,
    }
  end
end

-- Enhanced yank highlighting
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Better paste behavior - don't replace register when pasting over selection
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set("v", "P", '"_dP', { desc = "Paste without yanking" })

-- System clipboard shortcuts
vim.keymap.set({"n", "v"}, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- Delete without yanking
vim.keymap.set({"n", "v"}, "<leader>d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set({"n", "v"}, "<leader>D", '"_D', { desc = "Delete line without yanking" })
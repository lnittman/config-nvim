-- disable line numbers in terminal buffers
return {
  {
    "LazyVim/LazyVim",
    opts = function()
      -- disable line numbers in terminal buffers
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
        end,
      })
      
      -- also apply to existing terminal buffers
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "term://*",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
        end,
      })
      
      return {}
    end,
  },
}
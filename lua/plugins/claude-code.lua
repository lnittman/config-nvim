return {
  -- Claude Code integration with terminal toggle
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      local toggleterm = require("toggleterm")
      toggleterm.setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = nil,
        hide_numbers = true,
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = false,
        terminal_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
      })

      -- Global variable to track Claude Code terminal
      local Terminal = require("toggleterm.terminal").Terminal
      _G.claude_code_terminal = Terminal:new({
        cmd = "claude",
        direction = "horizontal",
        hidden = true,
        count = 99, -- Use a high count to avoid conflicts
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<esc>", { noremap = true, silent = true })
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      -- Create commands that work from any buffer
      vim.api.nvim_create_user_command("ClaudeCodeToggle", function()
        _G.claude_code_terminal:toggle()
      end, { desc = "Toggle Claude Code terminal" })

      vim.api.nvim_create_user_command("ClaudeCodeReload", function()
        vim.cmd("checktime")
        vim.notify("Reloaded all buffers", vim.log.levels.INFO)
      end, { desc = "Reload all buffers" })

      -- Set up keymaps
      vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCodeToggle<cr>", { desc = "Toggle Claude Code", silent = true })
      vim.keymap.set("n", "<leader>cr", "<cmd>ClaudeCodeReload<cr>", { desc = "Reload modified files", silent = true })
    end,
  },
}
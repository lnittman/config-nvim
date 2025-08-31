-- GitHub theme with easy light/dark switching
return {
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          styles = {
            comments = "NONE",
            keywords = "NONE",
            functions = "NONE",
            variables = "NONE",
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
          transparent = false,
          dim_inactive = false,
        },
      })
      
      -- Theme switcher function (only for current session)
      _G.toggle_theme = function()
        local current = vim.g.colors_name
        if current == "github_light" then
          vim.cmd("colorscheme github_dark")
          vim.notify("switched to dark mode", vim.log.levels.INFO)
        else
          vim.cmd("colorscheme github_light")
          vim.notify("switched to light mode", vim.log.levels.INFO)
        end
        -- Don't save preference - always start fresh with light mode
      end
      
      -- Always start with light mode
      vim.cmd("colorscheme github_light")
      
      -- Set up keybindings
      vim.keymap.set("n", "<leader>ut", function()
        _G.toggle_theme()
      end, { desc = "toggle light/dark theme" })
      
      vim.keymap.set("n", "<F5>", function()
        _G.toggle_theme()
      end, { desc = "toggle theme" })
    end,
  },
}
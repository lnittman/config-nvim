-- simple custom dashboard with left-aligned layout
return {
  {
    "folke/snacks.nvim",
    opts = function()

      return {
        dashboard = {
          enabled = true,
          preset = {
            -- minimal left-aligned greeting
            header = [[
hello luke
            ]],
            keys = {
              { key = "f", desc = "f - find file", action = ":lua Snacks.dashboard.pick('files')" },
              { key = "n", desc = "n - new file", action = ":ene | startinsert" },
              { key = "g", desc = "g - find text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { key = "r", desc = "r - recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { key = "c", desc = "c - config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
              { key = "s", desc = "s - restore session", section = "session" },
              { key = "t", desc = "t - terminal", action = ":terminal" },
              { key = "x", desc = "x - lazy extras", action = ":LazyExtras" },
              { key = "l", desc = "l - lazy", action = ":Lazy" },
              { key = "q", desc = "q - quit", action = ":qa" },
            },
            -- no footer or plugin load time
          },
          sections = {
            { section = "header", padding = 1, align = "left" },
            { section = "keys", padding = 0, gap = 0, align = "left" },
          },
          -- minimal dashboard: header + keys only
        },
      }
    end,
  },
}

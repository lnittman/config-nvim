-- simple custom dashboard with left-aligned layout
return {
  {
    "folke/snacks.nvim",
    opts = function()
      local uv = vim.uv or vim.loop

      -- Minimal keys grid: letters only, tooltip on first press, execute on second press
      local function keys_grid_section()
        local function make_action(desc, cmd)
          _G._dash_hint = _G._dash_hint or { last = nil, when = 0 }
          return function()
            local now = vim.uv and vim.uv.now and (vim.uv.now() / 1000) or (vim.loop.now() / 1000)
            local last = _G._dash_hint.last
            local dt = now - (_G._dash_hint.when or 0)
            if last == desc and dt < 0.6 then
              -- second press quickly -> run
              if type(cmd) == "string" and cmd:sub(1,1) == ":" then
                vim.cmd(cmd:sub(2))
              elseif type(cmd) == "function" then
                cmd()
              end
              _G._dash_hint.last, _G._dash_hint.when = nil, 0
            else
              -- show tooltip on first press
              vim.notify(desc, vim.log.levels.INFO, { title = "dashboard" })
              _G._dash_hint.last, _G._dash_hint.when = desc, now
              -- auto-clear after 1.2s
              vim.defer_fn(function()
                if _G._dash_hint and _G._dash_hint.last == desc then
                  _G._dash_hint.last, _G._dash_hint.when = nil, 0
                end
              end, 1200)
            end
          end
        end

        local items = {
          { key = "f", text = { "f" }, desc = "find file", action = make_action("find file", ":lua Snacks.dashboard.pick('files')") },
          { key = "n", text = { "n" }, desc = "new file", action = make_action("new file", ":ene | startinsert") },
          { key = "g", text = { "g" }, desc = "find text", action = make_action("find text", ":lua Snacks.dashboard.pick('live_grep')") },
          { key = "r", text = { "r" }, desc = "recent files", action = make_action("recent files", ":lua Snacks.dashboard.pick('oldfiles')") },
          { key = "c", text = { "c" }, desc = "config", action = make_action("config", function() Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') }) end) },
          { key = "s", text = { "s" }, desc = "restore session", section = "session" },
          { key = "t", text = { "t" }, desc = "terminal", action = make_action("terminal", ":terminal") },
          { key = "x", text = { "x" }, desc = "lazy extras", action = make_action("lazy extras", ":LazyExtras") },
          { key = "l", text = { "l" }, desc = "lazy", action = make_action("lazy", ":Lazy") },
          { key = "q", text = { "q" }, desc = "quit", action = make_action("quit", ":qa") },
        }

        -- Distribute across panes (columns). Keep default pane width; Snacks will compute columns automatically.
        local col = 1
        local max_cols = 5
        for _, it in ipairs(items) do
          it.pane = col
          it.align = "center"
          col = col + 1
          if col > max_cols then col = 1 end
        end
        return items
      end

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
          -- No special formats; our keys grid uses `text` to render letters only
        },
      }
    end,
  },
}

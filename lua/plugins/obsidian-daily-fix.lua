-- fix daily note navigation to use templates
return {
  "epwalsh/obsidian.nvim",
  opts = function(_, opts)
    -- Override the gf mapping to handle daily notes specially
    opts.mappings = opts.mappings or {}
    opts.mappings["gf"] = {
      action = function()
        local util = require("obsidian.util")
        local client = require("obsidian").get_client()
        
        -- Get the link under cursor
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2] + 1
        
        -- Find wiki link boundaries
        local link_start = nil
        local link_end = nil
        
        -- Search backwards for [[
        for i = col, 1, -1 do
          if line:sub(i-1, i) == "[[" then
            link_start = i + 1
            break
          end
        end
        
        -- Search forwards for ]]
        if link_start then
          for i = col, #line - 1 do
            if line:sub(i, i+1) == "]]" then
              link_end = i - 1
              break
            end
          end
        end
        
        if link_start and link_end then
          local link = line:sub(link_start, link_end)
          
          -- Check if this is a daily note link (format: daily/YYYY-MM-DD)
          local daily_date = link:match("^daily/(%d%d%d%d%-%d%d%-%d%d)$")
          
          if daily_date then
            -- Use ObsidianDailyNote command to create with template
            vim.cmd("ObsidianDailyNote " .. daily_date)
          else
            -- Regular link navigation
            return util.gf_passthrough()
          end
        else
          -- Not on a link, use default behavior
          return util.gf_passthrough()
        end
      end,
      opts = { noremap = false, expr = true, buffer = true },
    }
    
    return opts
  end,
}
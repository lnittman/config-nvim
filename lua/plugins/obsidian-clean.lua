-- clean obsidian setup with minimal frontmatter and tag management
return {
  -- which-key group for Obsidian (new spec format)
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>o", group = "obsidian" })
      return opts
    end,
  },

  {
    "epwalsh/obsidian.nvim",
    opts = {
      -- Minimize frontmatter generation
      note_frontmatter_func = function(note)
        -- Only add what we explicitly want
        local out = { 
          tags = note.tags,
          date = note.id -- Use the ID as date for daily notes
        }
        
        -- Don't add id, aliases, or other auto-generated fields
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            if k ~= "id" and k ~= "aliases" and k ~= "linter-yaml-title-alias" then
              out[k] = v
            end
          end
        end
        
        return out
      end,
      
      -- Disable automatic daily-notes tag
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        template = "daily.md",
        -- Don't add any default tags - let template handle it
        default_tags = nil,
      },
    }
  },
  
  -- Create tag management keybinding
  {
    "epwalsh/obsidian.nvim",
    keys = {
      { 
        "<leader>otg", 
        function()
          -- Create tag manager
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          local entry_display = require("telescope.pickers.entry_display")
          
          -- Common tags for quick access
          local common_tags = {
            "daily", "notes", "project", "idea", "meeting",
            "todo", "done", "urgent", "review", "research",
            "bug", "feature", "doc", "personal", "work"
          }
          
          -- Get current buffer's frontmatter
          local bufnr = vim.api.nvim_get_current_buf()
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local current_tags = {}
          local in_frontmatter = false
          local tags_line_num = nil
          
          for i, line in ipairs(lines) do
            if i == 1 and line == "---" then
              in_frontmatter = true
            elseif in_frontmatter and line == "---" then
              break
            elseif in_frontmatter and line:match("^tags:") then
              tags_line_num = i
              -- Parse existing tags
              local tags_str = line:match("^tags:%s*%[(.*)%]")
              if tags_str then
                for tag in tags_str:gmatch("[^,%s]+") do
                  table.insert(current_tags, tag)
                end
              end
            end
          end
          
          -- Create picker entries
          local entries = {}
          for _, tag in ipairs(common_tags) do
            local is_active = vim.tbl_contains(current_tags, tag)
            table.insert(entries, {
              tag = tag,
              active = is_active,
              display = string.format("%s %s", is_active and "✓" or " ", tag)
            })
          end
          
          local picker = pickers.new({}, {
            prompt_title = "manage tags",
            finder = finders.new_table({
              results = entries,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = entry.display,
                  ordinal = entry.tag,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                if selection then
                  local tag = selection.value.tag
                  local is_active = selection.value.active
                  
                  -- Toggle tag
                  if is_active then
                    -- Remove tag
                    for i, t in ipairs(current_tags) do
                      if t == tag then
                        table.remove(current_tags, i)
                        break
                      end
                    end
                  else
                    -- Add tag
                    table.insert(current_tags, tag)
                  end
                  
                  -- Update frontmatter
                  if tags_line_num then
                    local new_tags_line = "tags: [" .. table.concat(current_tags, ", ") .. "]"
                    vim.api.nvim_buf_set_lines(bufnr, tags_line_num - 1, tags_line_num, false, {new_tags_line})
                  end
                  
                  -- Refresh picker
                  actions.close(prompt_bufnr)
                  vim.schedule(function()
                    vim.cmd("normal! <leader>otg")
                  end)
                end
              end)
              
              -- Add custom tag with 'n'
              map("i", "<C-n>", function()
                local new_tag = vim.fn.input("new tag: ")
                if new_tag and new_tag ~= "" then
                  table.insert(current_tags, new_tag)
                  if tags_line_num then
                    local new_tags_line = "tags: [" .. table.concat(current_tags, ", ") .. "]"
                    vim.api.nvim_buf_set_lines(bufnr, tags_line_num - 1, tags_line_num, false, {new_tags_line})
                  end
                  actions.close(prompt_bufnr)
                end
              end)
              
              return true
            end,
          })
          
          picker:find()
        end,
        desc = "manage tags"
      },
    }
  }
}

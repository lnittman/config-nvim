-- Buffer manager with home row keybinding
return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader><leader>", desc = "Buffer manager" },
      { "<leader>,", desc = "Previous buffer" },
      { "<leader>.", desc = "Next buffer" },
    },
    config = function()
      -- Enhanced buffer picker
      local function buffer_manager()
        local telescope = require("telescope")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local previewers = require("telescope.previewers")
        local entry_display = require("telescope.pickers.entry_display")
        
        -- Get all buffers
        local buffers = {}
        local current_buf = vim.api.nvim_get_current_buf()
        
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
            local name = vim.api.nvim_buf_get_name(buf)
            local short_name = name:match("([^/]+)$") or name
            
            -- Get file type
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
            
            -- Determine icon and type
            local icon = ""
            local type_str = ft ~= "" and ft or "text"
            
            if buftype == "terminal" then
              icon = ""
              type_str = "terminal"
              -- Try to get custom terminal name
              if _G.terminal_names and _G.terminal_names[buf] then
                short_name = _G.terminal_names[buf]
              end
            elseif ft == "lua" then
              icon = ""
            elseif ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
              icon = ""
            elseif ft == "python" then
              icon = ""
            elseif ft == "rust" then
              icon = ""
            elseif ft == "go" then
              icon = ""
            elseif ft == "markdown" then
              icon = ""
            elseif ft == "json" then
              icon = ""
            elseif ft == "yaml" then
              icon = ""
            elseif ft == "toml" then
              icon = ""
            elseif ft == "html" then
              icon = ""
            elseif ft == "css" then
              icon = ""
            elseif ft == "vim" then
              icon = ""
            end
            
            -- Check if modified
            local modified = vim.api.nvim_buf_get_option(buf, "modified")
            local modified_str = modified and "●" or ""
            
            table.insert(buffers, {
              buf = buf,
              name = name,
              short_name = short_name,
              icon = icon,
              type = type_str,
              modified = modified_str,
              is_current = buf == current_buf,
              last_used = vim.fn.getbufinfo(buf)[1].lastused or 0,
            })
          end
        end
        
        -- Sort by last used
        table.sort(buffers, function(a, b)
          return a.last_used > b.last_used
        end)
        
        -- Create the picker
        pickers.new({}, {
          prompt_title = "buffers",
          finder = finders.new_table({
            results = buffers,
            entry_maker = function(entry)
              local displayer = entry_display.create({
                separator = " ",
                items = {
                  { width = 1 },  -- Current marker
                  { width = 1 },  -- Modified marker
                  { width = 2 },  -- Icon
                  { remaining = true },  -- Name
                  { width = 15 },  -- Type
                },
              })
              
              local function make_display(e)
                return displayer({
                  e.value.is_current and "●" or " ",
                  e.value.modified,
                  e.value.icon,
                  e.value.short_name,
                  "(" .. e.value.type .. ")",
                })
              end
              
              return {
                value = entry,
                display = make_display,
                ordinal = entry.short_name .. " " .. entry.name,
                buf = entry.buf,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          previewer = previewers.new_buffer_previewer({
            title = "buffer preview",
            get_buffer_by_name = function(_, entry)
              return entry.buf
            end,
            define_preview = function(self, entry)
              if vim.api.nvim_buf_is_valid(entry.buf) then
                -- Show buffer content
                local lines = vim.api.nvim_buf_get_lines(entry.buf, 0, 100, false)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                
                -- Set filetype for syntax highlighting
                local ft = vim.api.nvim_buf_get_option(entry.buf, "filetype")
                if ft and ft ~= "" then
                  vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", ft)
                end
              end
            end,
          }),
          attach_mappings = function(prompt_bufnr, map)
            -- Select buffer
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                vim.api.nvim_set_current_buf(selection.value.buf)
              end
            end)
            
            -- Delete buffer with 'd'
            map("n", "d", function()
              local selection = action_state.get_selected_entry()
              if selection then
                vim.api.nvim_buf_delete(selection.value.buf, { force = false })
                -- Refresh picker
                actions.close(prompt_bufnr)
                vim.defer_fn(buffer_manager, 50)
              end
            end)
            
            -- Force delete with 'D'
            map("n", "D", function()
              local selection = action_state.get_selected_entry()
              if selection then
                vim.api.nvim_buf_delete(selection.value.buf, { force = true })
                -- Refresh picker
                actions.close(prompt_bufnr)
                vim.defer_fn(buffer_manager, 50)
              end
            end)
            
            -- Split operations
            map("n", "s", function()
              local selection = action_state.get_selected_entry()
              if selection then
                actions.close(prompt_bufnr)
                vim.cmd("split")
                vim.api.nvim_set_current_buf(selection.value.buf)
              end
            end)
            
            map("n", "v", function()
              local selection = action_state.get_selected_entry()
              if selection then
                actions.close(prompt_bufnr)
                vim.cmd("vsplit")
                vim.api.nvim_set_current_buf(selection.value.buf)
              end
            end)
            
            return true
          end,
          layout_strategy = vim.o.columns > 100 and "horizontal" or "vertical",
          layout_config = {
            prompt_position = "top",
            width = function() return math.min(vim.o.columns, 120) end,
            height = function() return math.min(vim.o.lines - 4, 30) end,
            preview_width = 0.6,
            preview_cutoff = 80,
          },
        }):find()
      end
      
      -- Quick buffer navigation
      local function next_buffer()
        vim.cmd("bnext")
      end
      
      local function prev_buffer()
        vim.cmd("bprevious")
      end
      
      -- Keymaps - double tap space for ultimate speed!
      vim.keymap.set("n", "<leader><leader>", buffer_manager, { desc = "Buffer manager" })
      vim.keymap.set("n", "<leader>,", prev_buffer, { desc = "Previous buffer" })
      vim.keymap.set("n", "<leader>.", next_buffer, { desc = "Next buffer" })
      
      -- Keep existing Tab/Shift-Tab mappings
      vim.keymap.set("n", "<Tab>", next_buffer, { desc = "Next buffer" })
      vim.keymap.set("n", "<S-Tab>", prev_buffer, { desc = "Previous buffer" })
    end,
  },
}
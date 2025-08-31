-- Native terminal buffer management with fuzzy finder
return {
  -- Remove toggleterm if it exists
  { "akinsho/toggleterm.nvim", enabled = false },
  
  -- Terminal buffer manager
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>a", desc = "Terminal manager" },
      { "<leader>an", desc = "New terminal" },
      { "<leader>at", desc = "Next terminal" },
      { "<leader>aT", desc = "Previous terminal" },
    },
    config = function()
      -- Terminal management state
      _G.terminal_buffers = _G.terminal_buffers or {}
      _G.terminal_names = _G.terminal_names or {}
      _G.terminal_counter = _G.terminal_counter or 0
      
      -- Check if buffer is a terminal
      local function is_terminal_buffer(buf)
        return vim.api.nvim_buf_is_valid(buf) and 
               vim.api.nvim_buf_get_option(buf, "buftype") == "terminal"
      end
      
      -- Create a new terminal buffer
      local function create_terminal(name)
        -- Create a new buffer
        local buf = vim.api.nvim_create_buf(true, false)
        
        -- Switch to that buffer
        vim.api.nvim_set_current_buf(buf)
        
        -- Start terminal
        vim.fn.termopen(vim.o.shell, {
          on_exit = function()
            -- Clean up when terminal exits
            _G.terminal_buffers[buf] = nil
            _G.terminal_names[buf] = nil
          end,
        })
        
        -- Track the terminal
        _G.terminal_counter = _G.terminal_counter + 1
        _G.terminal_buffers[buf] = {
          id = _G.terminal_counter,
          created = os.time(),
          last_accessed = os.time(),
        }
        
        -- Set name
        local final_name = name or ("shell " .. _G.terminal_counter)
        _G.terminal_names[buf] = final_name
        
        -- Enter insert mode
        vim.cmd("startinsert")
        
        return buf
      end
      
      -- Switch to terminal buffer
      local function switch_to_terminal(buf)
        if buf and vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_set_current_buf(buf)
          if _G.terminal_buffers[buf] then
            _G.terminal_buffers[buf].last_accessed = os.time()
          end
          vim.cmd("startinsert")
        end
      end
      
      -- Get all valid terminal buffers
      local function get_terminal_buffers()
        local terminals = {}
        for buf, info in pairs(_G.terminal_buffers) do
          if is_terminal_buffer(buf) then
            table.insert(terminals, {
              buf = buf,
              info = info,
              name = _G.terminal_names[buf] or ("shell " .. info.id)
            })
          else
            -- Clean up invalid buffers
            _G.terminal_buffers[buf] = nil
            _G.terminal_names[buf] = nil
          end
        end
        -- Sort by last accessed
        table.sort(terminals, function(a, b)
          return (a.info.last_accessed or 0) > (b.info.last_accessed or 0)
        end)
        return terminals
      end
      
      -- Terminal picker using Telescope
      local function show_terminal_picker()
        local telescope = require("telescope")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local previewers = require("telescope.previewers")
        
        -- Build list of terminals
        local term_list = {}
        
        -- Add create new option at the top
        table.insert(term_list, {
          buf = nil,
          name = "+ create new terminal",
          id = "new",
          is_new = true,
        })
        
        -- Add existing terminals
        local terminals = get_terminal_buffers()
        for _, term in ipairs(terminals) do
          table.insert(term_list, {
            buf = term.buf,
            name = term.name,
            id = term.info.id,
            last_accessed = term.info.last_accessed,
            is_current = (term.buf == vim.api.nvim_get_current_buf()),
          })
        end
        
        pickers.new({}, {
          prompt_title = "terminals",
          finder = finders.new_table({
            results = term_list,
            entry_maker = function(entry)
              local display
              if entry.is_new then
                display = entry.name
              else
                local icon = entry.is_current and "●" or "○"
                display = string.format("%s %s", icon, entry.name)
              end
              
              return {
                value = entry,
                display = display,
                ordinal = entry.name,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          previewer = previewers.new_buffer_previewer({
            title = "terminal preview",
            get_buffer_by_name = function(_, entry)
              if entry and entry.value then
                return entry.value.buf
              end
            end,
            define_preview = function(self, entry)
              if entry.value.buf and vim.api.nvim_buf_is_valid(entry.value.buf) then
                -- Show terminal buffer content
                local lines = vim.api.nvim_buf_get_lines(entry.value.buf, -100, -1, false)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
              else
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
                  "press enter to create a new terminal"
                })
              end
            end,
          }),
          attach_mappings = function(prompt_bufnr, map)
            -- Select/create terminal
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection and selection.value then
                if selection.value.is_new then
                  -- Prompt for name
                  vim.ui.input({
                    prompt = "terminal name (optional): ",
                  }, function(name)
                    if name ~= nil then -- Allow empty string
                      create_terminal(name == "" and nil or name)
                    end
                  end)
                else
                  switch_to_terminal(selection.value.buf)
                end
              end
            end)
            
            -- Rename with 'r'
            map("n", "r", function()
              local selection = action_state.get_selected_entry()
              if selection and selection.value and selection.value.buf then
                local current_name = _G.terminal_names[selection.value.buf]
                vim.ui.input({
                  prompt = "rename terminal: ",
                  default = current_name,
                }, function(new_name)
                  if new_name and new_name ~= "" then
                    _G.terminal_names[selection.value.buf] = new_name
                    -- Refresh picker
                    actions.close(prompt_bufnr)
                    vim.defer_fn(show_terminal_picker, 50)
                  end
                end)
              end
            end)
            
            -- Delete with 'd'
            map("n", "d", function()
              local selection = action_state.get_selected_entry()
              if selection and selection.value and selection.value.buf then
                local buf = selection.value.buf
                _G.terminal_buffers[buf] = nil
                _G.terminal_names[buf] = nil
                vim.api.nvim_buf_delete(buf, { force = true })
                -- Refresh picker
                actions.close(prompt_bufnr)
                vim.defer_fn(show_terminal_picker, 50)
              end
            end)
            
            -- Create new with 'n'
            map("n", "n", function()
              actions.close(prompt_bufnr)
              vim.ui.input({
                prompt = "terminal name (optional): ",
              }, function(name)
                if name ~= nil then
                  create_terminal(name == "" and nil or name)
                end
              end)
            end)
            
            return true
          end,
          layout_strategy = vim.o.columns > 100 and "horizontal" or "vertical",
          layout_config = {
            prompt_position = "top",
            width = function() return vim.o.columns end,
            height = function() return vim.o.lines - 4 end,
            preview_width = 0.65,
            preview_cutoff = 80, -- Hide preview if window width < 80 columns
            horizontal = {
              mirror = false,
              preview_cutoff = 80,
            },
            vertical = {
              mirror = false,
              preview_cutoff = 80,
            },
          },
        }):find()
      end
      
      -- Navigate to next terminal buffer
      local function next_terminal()
        local current_buf = vim.api.nvim_get_current_buf()
        local terminals = get_terminal_buffers()
        
        if #terminals == 0 then
          vim.notify("No terminal buffers", vim.log.levels.INFO)
          return
        end
        
        -- Find current position
        local current_idx = nil
        for i, term in ipairs(terminals) do
          if term.buf == current_buf then
            current_idx = i
            break
          end
        end
        
        -- Go to next or first
        local next_idx = current_idx and (current_idx % #terminals) + 1 or 1
        switch_to_terminal(terminals[next_idx].buf)
      end
      
      -- Navigate to previous terminal buffer
      local function prev_terminal()
        local current_buf = vim.api.nvim_get_current_buf()
        local terminals = get_terminal_buffers()
        
        if #terminals == 0 then
          vim.notify("No terminal buffers", vim.log.levels.INFO)
          return
        end
        
        -- Find current position
        local current_idx = nil
        for i, term in ipairs(terminals) do
          if term.buf == current_buf then
            current_idx = i
            break
          end
        end
        
        -- Go to previous or last
        local prev_idx = current_idx and (current_idx - 2) % #terminals + 1 or #terminals
        switch_to_terminal(terminals[prev_idx].buf)
      end
      
      -- Commands
      vim.api.nvim_create_user_command("Term", function(opts)
        create_terminal(opts.args ~= "" and opts.args or nil)
      end, { nargs = "?", desc = "Create new terminal with optional name" })
      
      vim.api.nvim_create_user_command("TermList", show_terminal_picker, 
        { desc = "Show terminal picker" })
      
      -- Keymaps - only in normal mode to avoid conflicts when typing
      vim.keymap.set("n", "<leader>a", show_terminal_picker, 
        { desc = "Terminal manager" })
      
      vim.keymap.set("n", "<leader>an", function()
        vim.ui.input({
          prompt = "terminal name (optional): ",
        }, function(name)
          if name ~= nil then
            create_terminal(name == "" and nil or name)
          end
        end)
      end, { desc = "New terminal" })
      
      -- Terminal-specific navigation - only in normal mode
      vim.keymap.set("n", "<leader>at", next_terminal, 
        { desc = "Next terminal" })
      vim.keymap.set("n", "<leader>aT", prev_terminal, 
        { desc = "Previous terminal" })
      
      -- Better terminal navigation
      vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
      vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window" })
      vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window" })
      vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })
      vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
      
      -- Auto-enter insert mode when entering terminal buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "term://*",
        callback = function(args)
          local buf = args.buf
          -- Register manually created terminals
          if not _G.terminal_buffers[buf] then
            _G.terminal_counter = _G.terminal_counter + 1
            _G.terminal_buffers[buf] = {
              id = _G.terminal_counter,
              created = os.time(),
              last_accessed = os.time(),
            }
            -- Try to extract name from buffer name
            local bufname = vim.api.nvim_buf_get_name(buf)
            local name = bufname:match("term://.*//(%d+):")
            _G.terminal_names[buf] = name and ("manual " .. name) or ("shell " .. _G.terminal_counter)
          end
          
          vim.defer_fn(function()
            if vim.api.nvim_get_mode().mode == 'n' then
              vim.cmd("startinsert")
            end
          end, 10)
        end,
      })
    end,
  },
  
  -- Update statusline to show terminal count
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Remove time if it exists
      if opts.sections and opts.sections.lualine_z then
        opts.sections.lualine_z = {}
      end
      
      -- Add terminal indicator
      local terminal_component = {
        function()
          local count = 0
          if _G.terminal_buffers then
            for buf, _ in pairs(_G.terminal_buffers) do
              if vim.api.nvim_buf_is_valid(buf) and 
                 vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
                count = count + 1
              end
            end
          end
          if count > 0 then
            return string.format(" %d", count)
          else
            return ""
          end
        end,
        color = { fg = "#7aa2f7", gui = "bold" },
      }
      
      -- Add to statusline
      if not opts.sections then opts.sections = {} end
      if not opts.sections.lualine_c then opts.sections.lualine_c = {} end
      table.insert(opts.sections.lualine_c, terminal_component)
      
      return opts
    end,
  },
}
-- Configure Neo-tree as fullscreen modal instead of sidebar
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- Make neo-tree a fullscreen modal
    window = {
      position = "float",
      popup = {
        size = {
          height = "100%",
          width = "100%",
        },
        position = "0%",
      },
      mappings = {
        ["<space>"] = "none",
        ["<esc>"] = "close_window",
        ["q"] = "close_window",
      },
    },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        ".DS_Store",
        ".git",
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".DS_Store",
          ".git",
        },
      },
    },
    -- Add nice icons and indentation
    default_component_configs = {
      indent = {
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        indent_size = 2,
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "",
      },
      modified = {
        symbol = "[+]",
      },
      git_status = {
        symbols = {
          added = "✚",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    },
  },
  keys = {
    -- Override the default keybindings to use fullscreen modal
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, position = "float" })
      end,
      desc = "Explorer NeoTree (float)",
    },
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, position = "float" })
      end,
      desc = "Explorer NeoTree (float)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({ 
          toggle = true, 
          position = "float",
          reveal = true,
        })
      end,
      desc = "Explorer NeoTree (reveal file)",
    },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true, position = "float" })
      end,
      desc = "Git explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true, position = "float" })
      end,
      desc = "Buffer explorer",
    },
  },
}
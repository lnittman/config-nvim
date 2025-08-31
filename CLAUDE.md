# AI-Native Neovim IDE (Terminal Agents)

This is a LazyVim-based configuration optimized for AI-assisted development using terminal-based coding agents.

## Key Features

- **Terminal Agents**: First-class terminal buffer workflows for coding agents (e.g., claude)
- **Keyboard-Driven**: All actions accessible without leaving the keyboard
- **Fast Fuzzy Finding**: Telescope with FZF for lightning-fast file navigation
- **Smart Window Management**: Intuitive splits and navigation

## Essential Keybindings

### Terminal Agents
- `<leader>a` - Terminal manager (picker)
- `<leader>an` - New terminal
- `<leader>at` - Next terminal
- `<leader>aT` - Previous terminal

### Window Management
- `<C-h/j/k/l>` - Navigate between windows
- `<leader>-` - Split window horizontally
- `<leader>|` - Split window vertically
- `<leader>tv` - Open terminal in vertical split
- `<leader>th` - Open terminal in horizontal split
- `<leader>wo` - Close other windows
- `<leader>wm` - Maximize current window
- `<leader>we` - Equal window sizes
- `<C-Arrow>` - Resize windows

### File Navigation
- `<leader><space>` or `<C-p>` - Find files
- `<leader>ff` - Find files
- `<leader>fr` - Recent files
- `<leader>fg` - Live grep (search in files)
- `<leader>fw` - Search word under cursor
- `<leader>fb` - Switch buffers
- `<leader>fp` - Find projects

### Quick Actions
- `<leader>w` - Save file
- `<leader>q` - Quit window
- `<leader>Q` - Quit all
- `;` - Enter command mode (faster than `:`)
- `<S-h/l>` - Previous/Next buffer

### Terminal Mode
- `<Esc><Esc>` - Exit terminal mode
- `<C-h/j/k/l>` - Navigate from terminal to other windows
- `<C-n>` - Normal mode in terminal

### Search & Replace
- `<leader>sg` - Search and replace globally
- `<leader>sb` - Search in current buffer
- `<leader>sr` - Resume last search

### Code Navigation
- `s` + 2 chars - Jump to any location (Leap)
- `<leader>ss` - Document symbols
- `<leader>sS` - Workspace symbols
- `<leader>u` - Toggle undo tree

### Text Manipulation
- `ys` + motion + char - Surround text
- `cs` + old + new - Change surrounding
- `ds` + char - Delete surrounding
- `<A-j/k>` - Move line/selection up/down
- `</>` in visual - Indent and reselect

## Workflow Tips

1. **Starting an Agent Session**:
   - Open a file in your project
   - Use `<leader>a` to manage terminals, or run `:terminal` and start your agent CLI (e.g., `claude -r`)
   - Terminal buffers run inside Neovim and have project access

2. **Efficient File Navigation**:
   - Use `<C-p>` for quick file access
   - Use `<leader>fg` to search content across files
   - Use `<leader>fr` for recently edited files

3. **Window Layouts**:
   - Keep your agent on the right: `<leader>sv` (vertical split), then `:terminal` (or `<leader>a` → new)
   - Use `<C-h/l>` to quickly switch between code and terminal
   - Use `<leader>wm` to focus on code, `<leader>we` to restore

4. **Quick Edits**:
   - Let agents make changes; buffers auto-reload
   - Run `:checktime` if files don't auto-reload
   - Use undo (`u`) if you don't like changes

## First Launch

When you first open Neovim:
1. LazyVim will automatically install all plugins
2. Wait for installation to complete
3. Restart Neovim
4. Run `:checkhealth` to ensure everything is working

## Requirements

- Neovim >= 0.10.1
- Agent CLIs as desired (e.g., `claude`) on PATH
- ripgrep (rg) for fast searching
- A Nerd Font for icons (optional but recommended)

## Customization

- Personal keymaps: `~/.config/nvim/lua/config/keymaps.lua`
- Additional plugins: Create files in `~/.config/nvim/lua/plugins/`
- Override LazyVim defaults: Use `opts` in plugin specs

Remember: This setup prioritizes efficiency and keyboard-driven workflows. Take time to learn the keybindings - they'll become muscle memory quickly!

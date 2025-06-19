# AI-Native Neovim IDE with Claude Code Integration

This is a LazyVim-based configuration optimized for AI-assisted development with Claude Code.

## Key Features

- **Claude Code Integration**: Seamless integration with Claude Code CLI
- **Keyboard-Driven**: All actions accessible without leaving the keyboard
- **Fast Fuzzy Finding**: Telescope with FZF for lightning-fast file navigation
- **Smart Window Management**: Intuitive splits and navigation

## Essential Keybindings

### Claude Code
- `<leader>cc` - Toggle Claude Code in terminal split
- `<leader>cr` - Reload files modified by Claude

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

1. **Starting Claude Code Session**:
   - Open a file you want to work on
   - Press `<leader>cc` to toggle Claude Code
   - Claude will have access to your current project

2. **Efficient File Navigation**:
   - Use `<C-p>` for quick file access
   - Use `<leader>fg` to search content across files
   - Use `<leader>fr` for recently edited files

3. **Window Layouts**:
   - Keep Claude Code on the right: `<leader>|` then `<leader>cc`
   - Use `<C-h/l>` to quickly switch between code and Claude
   - Use `<leader>wm` to focus on code, `<leader>we` to restore

4. **Quick Edits**:
   - Let Claude make changes, they auto-reload
   - Use `<leader>cr` if files don't auto-reload
   - Use undo (`u`) if you don't like changes

## First Launch

When you first open Neovim:
1. LazyVim will automatically install all plugins
2. Wait for installation to complete
3. Restart Neovim
4. Run `:checkhealth` to ensure everything is working

## Requirements

- Neovim >= 0.10.1
- Claude Code CLI installed and configured
- ripgrep (rg) for fast searching
- A Nerd Font for icons (optional but recommended)

## Customization

- Personal keymaps: `~/.config/nvim/lua/config/keymaps.lua`
- Additional plugins: Create files in `~/.config/nvim/lua/plugins/`
- Override LazyVim defaults: Use `opts` in plugin specs

Remember: This setup prioritizes efficiency and keyboard-driven workflows. Take time to learn the keybindings - they'll become muscle memory quickly!
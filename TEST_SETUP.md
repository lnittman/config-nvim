# Testing Your AI-Native Neovim Setup

## Initial Launch Test

1. **Open Neovim**: Run `nvim` in your terminal
   - LazyVim should start installing plugins automatically
   - Wait for all plugins to install (progress shown at bottom)

2. **Restart Neovim**: Exit with `:q` and reopen
   - Should load without errors

3. **Health Check**: Run `:checkhealth`
   - Check for any ERROR messages
   - Warnings are usually OK

## Claude Code Integration Test

1. **Open a test file**: `nvim test.py`

2. **Toggle Claude Code**: Press `<Space>cc`
   - Should open Claude in a vertical split
   - Try typing a command in Claude

3. **Test auto-reload**: 
   - Ask Claude to modify the test.py file
   - Changes should appear automatically

## Fuzzy Finder Test

1. **Find files**: Press `<Ctrl-p>`
   - Should open file finder
   - Type to filter files

2. **Live grep**: Press `<Space>fg`
   - Should search content in files

3. **Recent files**: Press `<Space>fr`
   - Should show recently edited files

## Window Management Test

1. **Create splits**:
   - `<Space>|` - Vertical split
   - `<Space>-` - Horizontal split

2. **Navigate windows**: Use `<Ctrl-h/j/k/l>`

3. **Terminal split**: Press `<Space>tv`
   - Should open terminal in vertical split
   - Press `<Esc><Esc>` to exit terminal mode

## Quick Verification Commands

Run these in Neovim command mode:

```vim
:Lazy sync           " Update all plugins
:Telescope           " Verify telescope is working
:ClaudeCodeToggle    " Test Claude integration
:LspInfo            " Check LSP status
```

## Common Issues

- **Claude Code not found**: Make sure `claude` command works in terminal
- **Plugins not loading**: Run `:Lazy sync` and restart
- **Icons not showing**: Install a Nerd Font
- **Slow startup**: Run `:Lazy profile` to identify slow plugins

If everything works, you're ready to start coding with your AI-native IDE!
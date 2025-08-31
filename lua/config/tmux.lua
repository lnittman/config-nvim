-- Enhanced tmux integration
local opt = vim.opt

-- Fix cursor visibility in tmux
if vim.env.TMUX then
  -- Enable cursor shape changing in tmux
  opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
    .. ",a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
    .. ",sm:block-blinkwait175-blinkoff150-blinkon175"

  -- Force cursor to be visible
  vim.cmd([[
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  ]])

  -- Fix color issues in tmux
  vim.cmd([[
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  ]])
end

-- Better cursor visibility settings
opt.cursorline = true
opt.cursorcolumn = false  -- Can enable for crosshair effect

-- Make cursor more visible with highlighting
vim.cmd([[
  hi Cursor guifg=black guibg=white
  hi CursorLine guibg=#1a1a1a
  hi CursorLineNr guifg=white guibg=#1a1a1a
]])

-- Fix autoread in tmux
opt.autoread = true
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold", "CursorHoldI"}, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Navigation is configured via plugin spec in lua/plugins/tmux-navigator.lua

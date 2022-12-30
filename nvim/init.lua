-- TODOs:
-- - [ ] Package manager
-- - [ ] Copilot
-- - [ ] Split into functions
-- - [ ] Generate docstrings via Copilot
-- - [ ] Try to add Lua linter in CI
-- - [ ] tnoremap <C-x><Esc> <C-\><C-n>
-- " Automatically resize splits after window size change
-- " https://coderwall.com/p/it7wka/vim-resplit-after-window-size-change
-- augroup Misc
--     autocmd!
--     autocmd VimResized * exe "normal! \<c-w>="
-- augroup END

-- Set hybrid numbers

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable", -- remove this if you want to bootstrap to HEAD
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    'ntpeters/vim-better-whitespace'
  }
}
require("lazy").setup(plugins)


vim.opt.nu = true
vim.opt.rnu = true

vim.opt.ignorecase = true
vim.opt.colorcolumn = "120"

vim.opt.linebreak = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.cursorline = true

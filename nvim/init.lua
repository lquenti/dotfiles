-- TODOs:
-- - [ ] LSP



function setup_lazy()
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
    'ntpeters/vim-better-whitespace',
    {
      'scrooloose/nerdtree',
      init = function()
        vim.cmd("nnoremap <silent> <C-x><C-f> :NERDTreeToggle<CR>")
        vim.cmd("let NERDTreeQuitOnOpen = 1")
      end
    },
    {
      'tomasiser/vim-code-dark',
      config = function()
        vim.cmd("colorscheme codedark")
      end
    },
    "github/copilot.vim",
    "neovim/nvim-lspconfig",
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate"
    },
  }
  require("lazy").setup(plugins)
end

function settings()
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

  vim.cmd("tnoremap <C-x><Esc> <C-\\><C-n>")

  vim.cmd([[
    " Automatically resize splits after window size change
    " https://coderwall.com/p/it7wka/vim-resplit-after-window-size-change
    augroup Misc
        autocmd!
        autocmd VimResized * exe "normal! \<c-w>="
    augroup END
  ]])
end

settings()
setup_lazy()

require'lspconfig'.rust_analyzer.setup{}

local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', "<C-x><C-D>", vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', "<C-x><C-d>", vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', "<C-x><C-i>", vim.lsp.buf.implementation, bufopts)

-- TODO properly port me
vim.api.nvim_command('autocmd FileType tex setlocal noautoindent')
vim.api.nvim_command('autocmd FileType tex setlocal nosmartindent')
vim.api.nvim_command('autocmd FileType tex setlocal indentexpr=')

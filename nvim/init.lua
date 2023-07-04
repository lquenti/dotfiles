
require "lquenti.options"
require "lquenti.keymaps"
require "lquenti.plugins"
require "lquenti.colorscheme"
require "lquenti.cmp"
require "lquenti.lsp"
require "lquenti.telescope"
require "lquenti.treesitter"
require "lquenti.nvimtree"
require "lquenti.bufferline"
require "lquenti.copilot"

  vim.cmd([[
    " Automatically resize splits after window size change
    " https://coderwall.com/p/it7wka/vim-resplit-after-window-size-change
    augroup Misc
        autocmd!
        autocmd VimResized * exe "normal! \<c-w>="
    augroup END
  ]])

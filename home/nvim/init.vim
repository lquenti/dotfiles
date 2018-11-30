set nu
set modelines=0
set t_vb=
set relativenumber
set completeopt-=preview " TODO: Own Function
set tabstop=2

call plug#begin()
" Begin Language-Client
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" End Language-Client

" Begin Spacemacs-theme-vim
Plug 'colepeters/spacemacs-theme.vim'
" End Spacemacs-theme-vim

" Begin vimtex
Plug 'lervag/vimtex'
" End vimtex
call plug#end()


" Begin General Language-Client Configuration
" Required for operations modifying multiple buffers like rename.
set hidden
let g:LanguageClient_serverCommands = {
    \ 'c': ['~/Documents/pkg/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
    \ 'cpp': ['~/Documents/pkg/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
    \ 'cuda': ['~/Documents/pkg/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
    \ 'objc': ['~/Documents/pkg/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
    \ 'python': ['~/.local/bin/pyls'],
\ }
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> <F6> :call LanguageClient#textDocument_completion()<CR>

let g:deoplete#enable_at_startup = 1
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '/home/YOUR_USERNAME/.config/nvim/settings.json'
" https://github.com/autozimu/LanguageClient-neovim/issues/379 LSP snippet is not supported
let g:LanguageClient_hasSnippetSupport = 0
" End General Language-Client Configuration

" Begin Spacemacs-theme-vim Configuration
if (has("termguicolors"))
  set termguicolors
endif
set background=dark
colorscheme spacemacs-theme
" End Spacemacs-theme-vim Configuration

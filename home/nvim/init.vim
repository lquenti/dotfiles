" Begin general configuration
" Set hybrid numbers
set nu
set rnu

" soft wrap
set linebreak

set shiftwidth=2 tabstop=2 expandtab

" Use Terminal Colors

" Setting a length marker at 80 char
" set colorcolumn=100

" Short form for:
" filetype on
"   - Tries to detect the language and set a filetype event for that language
"   - All other filetype commands will turn it on implicitly as well
" filetype indent on
"   - loading indent files for specific file types
" filetype plugin on
"   - loads filetype specific plugins
filetype plugin indent on

" Disable visual beep
set t_vb=0

" Set cursor highlightning
set cursorline
" End general configuration

call plug#begin()

" Begin NerdTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons' " Require nerdfont
" End NerdTree

" Begin Airline
Plug 'vim-airline/vim-airline'
" End Airline

" Begin indentLine (shows indentation)
Plug 'Yggdroot/indentLine'
" End indentLine

" Begin vim-surround
Plug 'tpope/vim-surround'
" End vim-surround

" Begin vim-startify
Plug 'mhinz/vim-startify'
" End vim-startify

" Begin LanguageClient-neovim 
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
" End LanguageClient-neovim 

" Begin vimtex
Plug 'lervag/vimtex'
" end vimtex

call plug#end()
colorscheme dim
" Set cursor line for the number part as well
let g:nord_cursor_line_number_background = 1
" End nord Configuration

" Begin NerdTree Configuration
" maps opening and closing NerdTree to C-x C-f
nnoremap <silent> <C-x><C-f> :NERDTreeToggle<CR>
" Hotfix because indentLine_leadingSpaceEnabled breaks nerdtrees indentation
" See: https://github.com/Yggdroot/indentLine/issues/152
autocmd BufEnter NERD_tree* :LeadingSpaceDisable
" Automatically close NERDTree when a file was opened
let NERDTreeQuitOnOpen = 1
" End NerdTree Configuration

" Begin indentLine configuration
let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled=1
let g:indentLine_fileTypeExclude = ['startify', ".py"]
" Disable at startify
" End indentLine configuration

" Begin airline configuration
" See: https://vi.stackexchange.com/questions/3359/how-do-i-fix-the-status-bar-symbols-in-the-airline-plugin
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
" end airline configuration

" Begin startify configuration
" TODO: Further configuration
let g:startify_fortune_use_unicode = 1
" End startify configuration

" Begin LanguageClient-neovim configuration
" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'c': ['~/pkg/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
    \ 'cpp': ['~/pkg/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
    \ 'cuda': ['~/pkg/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
    \ 'objc': ['~/pkg/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
" End LanguageClient-neovim configuration

" Begin vimtex configuration
" Otherwise sometimes it will detect latex as tex (see vimtexdocs)
let g:tex_flavour = 'latex' 
" Disbale those awful math symbol conversion
let g:tex_conceal = ""
" End vimtex configuration

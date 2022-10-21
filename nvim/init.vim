" Begin general configuration
" Set hybrid numbers
set nu
set rnu

" Disable autohiding of quotes in json
set conceallevel=0
" Somehow, this isn't enough for LaTeX therefore
let g:tex_conceal = ''

" 120 chars are probably a sensible limit
set colorcolumn=120

" https://medium.com/usevim/vim-101-set-hidden-f78800142855
" (can also cause a soft block with coc.nvim, see https://medium.com/usevim/vim-101-set-hidden-f78800142855 )
set hidden

" Ignore comments in JSON to be compatible with JSONC
" Stolen from https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file
autocmd FileType json syntax match Comment +\/\/.\+$+

" Indentation for inline css/js
" https://stackoverflow.com/questions/34967130/vim-right-way-to-indent-css-and-js-inside-html
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" soft wrap
set linebreak

" Short form for:
" filetype on
"   - Tries to detect the language and set a filetype event for that language
"   - All other filetype commands will turn it on implicitly as well
" filetype indent on
"   - loading indent files for specific file types
" filetype plugin on
"   - loads filetype specific plugins
filetype plugin indent on
" I want TAB to 2 spaces for now
" On pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2

" Disable visual beep
set t_vb=0

" Set cursor highlightning
set cursorline


" Needed for rust.vim to be explicitly enabled
syntax enable

" Escape temrminal with C-x<ESC> (more layout friendly)
tnoremap <C-x><Esc> <C-\><C-n>

" Automatically resize splits after window size change
" https://coderwall.com/p/it7wka/vim-resplit-after-window-size-change
augroup Misc
    autocmd!
    autocmd VimResized * exe "normal! \<c-w>="
augroup END

" End general configuration

call plug#begin()

" Begin NerdTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
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

" Begin vim-closetag
Plug 'alvan/vim-closetag'
" End vim-closetag

" Begin vim-better-whitespace
"
" Found here: https://stackoverflow.com/a/47048068/9958281
" Read question for usage context
Plug 'ntpeters/vim-better-whitespace'
" End vim-better-whitespace

" Begin vim-code-dark
Plug 'tomasiser/vim-code-dark'
" End vim-code-dark

" Begin distraction free
Plug 'junegunn/goyo.vim'
" End distraction free

" Begin coloured brackets
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1
" End coloured brackets
call plug#end()
colorscheme codedark


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
" https://github.com/Yggdroot/indentLine/issues/140#issuecomment-596280543
let g:indentLine_concealcursor = ''
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

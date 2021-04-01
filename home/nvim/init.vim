" Begin general configuration
" Set hybrid numbers
set nu
set rnu

" Disable autohiding of quotes in json
set conceallevel=0
" Somehow, this isn't enough for LaTeX therefore
let g:tex_conceal = ''

" https://medium.com/usevim/vim-101-set-hidden-f78800142855
" (can also cause a soft block with coc.nvim, see https://medium.com/usevim/vim-101-set-hidden-f78800142855 )
set hidden

" According to coc.nvim some language servers have issues with backup files,
" therefore
" See: https://github.com/neoclide/coc.nvim/issues/649
set nobackup
set nowritebackup

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

" Disable visual beep
set t_vb=0

" Set cursor highlightning
set cursorline


" Needed for rust.vim to be explicitly enabled
syntax enable

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

" Begin Linuxsty (kernel style guide)
Plug 'vivien/vim-linux-coding-style'
" End Linuxsty

" Begin coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" End coc.nvim

" Begin vim-better-whitespace
"
" Found here: https://stackoverflow.com/a/47048068/9958281
" Read question for usage context
Plug 'ntpeters/vim-better-whitespace'
" End vim-better-whitespace


" Begin vim-startify
Plug 'mhinz/vim-startify'
" End vim-startify

" Begin vim-code-dark
Plug 'tomasiser/vim-code-dark'
" End vim-code-dark

" Begin vim-devicons
"
" NOTE: This has to be loaded last
" From the wiki
" Set VimDevIcons to load after these plugins!
" NERDTree | vim-airline | CtrlP | powerline | Denite | unite | lightline.vim | vim-startify | vimfiler | flagship
Plug 'ryanoasis/vim-devicons' " Require nerdfont
" End vim-devicons
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


" Begin coc.nvim Configuration

" coc wrapps lsp servers into coc extensions, in order to improve their
" integration. This also helps since coc is written in node, therefore they
" can just fork the vsc plugins

" Usually, the extensions are installed with
" :CocInstall coc-json
" (or if you are using the terminal with -c for command)
" nvim -c 'CocInstall -sync coc-json'

" In order to ensure that all extensions are available on a new machine, coc
" allows global extensions to be defined. I quote the wiki:
"
" Note you can add extension names to the g:coc_global_extensions variable, and
" coc will install the missing extensions after coc.nvim service started.
"
" (See: https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#install-extensions)

" One can also find all extensions with :CocList extensions
" (the multiline comment syntax is defined unter :help line-continuation{,-comment}
let g:coc_global_extensions = [
	\'coc-tsserver',
	\'coc-go',
	\'coc-prettier'
	\]


" This maps the Type Hinting.
" <silent> means that it doesn't need to echo into the buffer
" Binded to <C-x><C-h>
nnoremap <silent> <C-x><C-h> :call CocAction('doHover')<CR>

nmap <silent> <C-x><C-d> <Plug>(coc-definition)
nmap <silent> <C-x><C-t> <Plug>(coc-type-definition)
nmap <silent> <C-x><C-r> <Plug>(coc-references)

" Actually define the ':Prettier' format
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" End coc.nvim Configuration

" Begin vim-startify configuration

" Use webdevicons with startify
let g:webdevicons_enable_startify = 1

" Set cool header
let g:ascii = [
	\'⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣴⣦⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
	\'⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀',
	\'⠀⠀⠀⠀⣠⣾⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣶⡀⠀⠀⠀⠀',
	\'⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⣶⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀⠀',
	\'⠀⠀⣼⣿⣿⠋⠀⠀⠀⠀⠀⠛⠛⢻⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀',
	\'⠀⢸⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⡇⠀',
	\'⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀',
	\'⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡟⢹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⠀',
	\'⠀⣿⣿⣷⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⣿⣿⡿⠀',
	\'⠀⢸⣿⣿⡆⠀⠀⠀⠀⣴⣿⡿⠃⠀⠀⠀⠈⢿⣿⣷⣤⣤⡆⠀⠀⣰⣿⣿⠇⠀',
	\'⠀⠀⢻⣿⣿⣄⠀⠀⠾⠿⠿⠁⠀⠀⠀⠀⠀⠘⣿⣿⡿⠿⠛⠀⣰⣿⣿⡟⠀⠀',
	\'⠀⠀⠀⠻⣿⣿⣧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠏⠀⠀⠀',
	\'⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⠟⠁⠀⠀⠀⠀',
	\'⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀',
	\'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
        \]
let g:startify_custom_header = 'startify#center(g:ascii) + startify#center(startify#fortune#boxed())'

" Bookmarks
let g:startify_bookmarks = [
	\'~/.config/nvim/init.vim',
	\'~/.zshrc',
	\'~/.config/awesome/rc.lua'
	\]

" (see g:startify_lists)
" NOTE: as for the indices, do not use keys also used by
" :h startify-mappings
let g:startify_lists = [
	\ {'type': 'files', 'header': ['   > Most recently used files']},
	\ {'type': 'bookmarks', 'header': ['   🔖 Bookmarks'], 'indices': ['a', 's', 'd']},
	\]

" End vim-startify configuration

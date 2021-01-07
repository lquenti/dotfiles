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

" Begin vim-closetag
Plug 'alvan/vim-closetag'
" End vim-closetag

" Begin rust.vim
Plug 'rust-lang/rust.vim'
" End rust.vim

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

" Begin fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" End fzf

call plug#end()

" Dim just uses ANSI colors therefore the config relies on the terminal
colorscheme dim


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

" Begin rust.vim Configuration
" Automatically run rustfmt when saved
" (this is basically the only function used besides
" the shorthand comments like
" :Ccheck, Crun, ...
" (See :help rust-commands)
let g:rustfmt_autosave = 1
" End rust.vim Configuration

" Begin coc.nvim Configuration

" TODO: Add support for the following coc-plugins:
"   - coc-markdownlint
"   - coc-discord{,-rpc} (dunno yet which one)
"   - coc-go (or is there any other more common tooling?)
"   - coc-pyright (or coc-jedi?)
"   - coc-vimtex (or texlab? (probably texlab))

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
	"\ coc-json is used for json validation
	"\ See: https://github.com/neoclide/coc-json
	\'coc-json',
	"\ coc-rls is a rls wrapper, forked from rls-vscode,
	"\ It expects the following packages to be installed
	"\ rustup component add rls rust-analysis rust-src
	"\ Further configuration is found unter nvim/coc-settings.json
	\'coc-rls'
	\]

" Now, we have to bind everything.
" See :help key-notation for the key names

" Firstly, we have to rebind <cr> (Enter) in order to react to completion when
" it is currently enabled
"
" inoremap replaces an mapping (:help inoremap)
" I think it is needed here because we would otherwise have a recursive
" definition.
"
" The <expr> part tells us, that the following is a complex expression instead
" of just a key (:help :map-<expr>)
"
" pumvisible checks whether the completion menu is visible (:help pumvisible)
"
" The ?: is the ternary operator, if it is visible it <CR> confirms the
" completion. If not it breaks the undo level and does a usual <CR>
" (See: https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#use-cr-to-confirm-completion)
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <TAB> and <S-Tab> (shift) to navigate the completion list.
"
" This one is simlilarly built and directly stolen from
" https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#use-tab-and-s-tab-to-navigate-the-completion-list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" TODO: Emacsify those bindings

" diagnostics as in warnings/errors on the left side
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> [G <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]G <Plug>(coc-diagnostic-next-error)

" GoTo code navigation.
nmap <silent> <M-g>d <Plug>(coc-definition)
" TODO: Is an type definition where the type is deducted
" (like int x;)
" or the class/struct definition?
nmap <silent> <M-g>t <Plug>(coc-type-definition)
" TODO: Understanding what an implementation is
nmap <silent> <C-c><C-f> <Plug>(coc-implementation)
" TODO: Understanding what a reference is
nmap <silent> <M-g>r <Plug>(coc-references)

" Symbol renaming.
nmap <C-c>r <Plug>(coc-rename)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Find symbol of current document.
nnoremap <silent><nowait> <C-f>s  :<C-u>CocList outline<cr>

" End coc.nvim Configuration

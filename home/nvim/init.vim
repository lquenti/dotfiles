" Begin general configuration
" Set hybrid numbers
set nu
set rnu

" Disable autohiding of quotes in json
set conceallevel=0
" Somehow, this isn't enough for LaTeX therefore
let g:tex_conceal = ''


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

" Begin coc (language server)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" End coc (language server)

" Begin rust.vim
Plug 'rust-lang/rust.vim'
" End rust.vim

" Begin Linuxsty (kernel style guide)
Plug 'vivien/vim-linux-coding-style'
" End Linuxsty

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


" Begin coc configuration

" This one is important: Make sure to not overshadow anything.
" By the time of the configuration, <TAB> was not set.
" One can check with :verbose imap <tab>
"
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" TODO: Add the rest after having some practise with coc 
" https://chmanie.com/post/2020/07/17/modern-c-development-in-neovim/

" End coc configuration

" Begin rust.vim Configuration
" Automatically run rustfmt when saved
let g:rustfmt_autosave = 1
" End rust.vim Configuration

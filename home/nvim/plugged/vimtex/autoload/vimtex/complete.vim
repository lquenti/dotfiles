" vimtex - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#complete#init_buffer() abort " {{{1
  if !g:vimtex_complete_enabled | return | endif

  " Prepare caches
  if !has_key(b:vimtex, 'complete')
    let b:vimtex.complete = {}
  endif
  if !has_key(b:vimtex.complete, 'bib')
    let b:vimtex.complete.bib = {}
  endif

  for l:completer in s:completers
    if has_key(l:completer, 'init')
      call l:completer.init()
    endif
  endfor

  setlocal omnifunc=vimtex#complete#omnifunc
endfunction

" }}}1

function! vimtex#complete#omnifunc(findstart, base) abort " {{{1
  if a:findstart
    if exists('s:completer') | unlet s:completer | endif

    let l:pos  = col('.') - 1
    let l:line = getline('.')[:l:pos-1]
    for l:completer in s:completers
      if !get(l:completer, 'enabled', 1) | continue | endif

      for l:pattern in l:completer.patterns
        if l:line =~# l:pattern
          let s:completer = l:completer
          while l:pos > 0
            if l:line[l:pos - 1] =~# '{\|,\|\[\|\\'
                  \ || l:line[l:pos-2:l:pos-1] ==# ', '
              let s:completer.context = matchstr(l:line,
                    \ get(s:completer, 're_context', '\S*$'))
              return l:pos
            else
              let l:pos -= 1
            endif
          endwhile
          return -2
        endif
      endfor
    endfor
    return -3
  else
    if !exists('s:completer') | return [] | endif

    return g:vimtex_complete_close_braces && get(s:completer, 'inside_braces', 1)
          \ ? s:close_braces(s:completer.complete(a:base))
          \ : s:completer.complete(a:base)
  endif
endfunction

" }}}1
function! vimtex#complete#complete(type, input, context) abort " {{{1
  try
    let s:completer = s:completer_{a:type}
    let s:completer.context = a:context
    return s:completer.complete(a:input)
  catch /E121/
    return []
  endtry
endfunction

" }}}1

"
" Completers
"
" {{{1 Bibtex

let s:completer_bib = {
      \ 'patterns' : [
      \   '\v\\\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*$',
      \   '\v\\bibentry\s*\{[^}]*$',
      \   '\v\\%(text|block)cquote\*?%(\s*\[[^]]*\]){0,2}\{[^}]*$',
      \   '\v\\%(for|hy)\w+cquote\*?\{[^}]*\}%(\s*\[[^]]*\]){0,2}\{[^}]*$',
      \  ],
      \ 'bibs' : '''\v%(%(\\@<!%(\\\\)*)@<=\%.*)@<!'
      \          . '\\(%(no)?bibliography|add(bibresource|globalbib|sectionbib))'
      \          . '\m\s*{\zs[^}]\+\ze}''',
      \ 'initialized' : 0,
      \}

function! s:completer_bib.init() dict abort " {{{2
  if self.initialized | return | endif
  let self.initialized = 1

  let self.patterns += g:vimtex_complete_bib.custom_patterns
endfunction

function! s:completer_bib.complete(regex) dict abort " {{{2
  let self.candidates = []

  for l:entry in self.gather_bib_entries()
    let cand = {'word': l:entry['key']}

    let auth = get(l:entry, 'author', 'Unknown')[:20]
    let auth = substitute(auth, '\~', ' ', 'g')
    let substitutes = {
          \ '@key' : l:entry['key'],
          \ '@type' : empty(l:entry['type']) ? '-' : l:entry['type'],
          \ '@author_all' : auth,
          \ '@author_short' : substitute(auth, ',.*\ze', ' et al.', ''),
          \ '@year' : get(l:entry, 'year', get(l:entry, 'date', '?')),
          \ '@title' : get(l:entry, 'title', 'No title'),
          \}

    " Create menu string
    if !empty(g:vimtex_complete_bib.menu_fmt)
      let cand.menu = copy(g:vimtex_complete_bib.menu_fmt)
      for [key, val] in items(substitutes)
        let cand.menu = substitute(cand.menu, key, escape(val, '&'), '')
      endfor
    endif

    " Create abbreviation string
    if !empty(g:vimtex_complete_bib.abbr_fmt)
      let cand.abbr = copy(g:vimtex_complete_bib.abbr_fmt)
      for [key, val] in items(substitutes)
        let cand.abbr = substitute(cand.abbr, key, escape(val, '&'), '')
      endfor
    endif

    call add(self.candidates, cand)
  endfor

  if g:vimtex_complete_bib.simple
    call s:filter_with_options(self.candidates, a:regex)
  else
    call s:filter_with_options(self.candidates, a:regex, {
          \ 'anchor': 0,
          \ 'filter_by_menu': 1,
          \})
  endif

  return self.candidates
endfunction

function! s:completer_bib.gather_bib_entries() dict abort " {{{2
  let l:entries = []

  " Note: bibtex seems to require that we are in the project root
  call vimtex#paths#pushd(b:vimtex.root)

  " Find data from external bib files
  for l:file in self.find_bibs()
    if empty(l:file) | continue | endif

    let l:filename = substitute(l:file, '\%(\.bib\)\?$', '.bib', '')
    if !filereadable(l:filename)
      let l:filename = vimtex#kpsewhich#find(l:filename)
    endif
    if !filereadable(l:filename) | continue | endif

    if !has_key(b:vimtex.complete.bib, l:file)
      let b:vimtex.complete.bib[l:file] = {'res': [], 'time': -1}
    endif

    let l:ftime = getftime(l:filename)
    if b:vimtex.complete.bib[l:file].time <= 0
          \ || l:ftime > b:vimtex.complete.bib[l:file].time
      let b:vimtex.complete.bib[l:file].time = l:ftime
      let b:vimtex.complete.bib[l:file].res = vimtex#parser#bib(l:filename)
    endif

    let l:entries += b:vimtex.complete.bib[l:file].res
  endfor

  " Revert earlier pushd
  call vimtex#paths#popd()

  " Find data from 'thebibliography' environments
  let l:entries += self.parse_thebibliography()

  return l:entries
endfunction

function! s:completer_bib.find_bibs() dict abort " {{{2
  "
  " Search for added bibliographies
  " * Parse commands such as \bibliography{file1,file2.bib,...}
  " * This also removes the .bib extensions
  "

  " Handle local file editing (e.g. subfiles package)
  let l:id = get(get(b:, 'vimtex_local', {'main_id' : b:vimtex_id}), 'main_id')
  let l:file = vimtex#state#get(l:id).tex

  let l:bibfiles = []
  let l:lines = vimtex#parser#tex(l:file, {'detailed' : 0})
  for l:entry in map(filter(l:lines, 'v:val =~ ' . self.bibs),
        \ 'matchstr(v:val, ' . self.bibs . ')')
    let l:entry = substitute(l:entry, '\\jobname', b:vimtex.name, 'g')
    let l:bibfiles += map(split(l:entry, ','), 'fnamemodify(v:val, '':r'')')
  endfor

  return vimtex#util#uniq(l:bibfiles)
endfunction

function! s:completer_bib.parse_thebibliography() dict abort " {{{2
  let l:res = []

  " Find data from 'thebibliography' environments
  let l:lines = readfile(b:vimtex.tex)
  if match(l:lines, '\C\\begin{thebibliography}') >= 0
    call filter(l:lines, 'v:val =~# ''\C\\bibitem''')

    for l:line in l:lines
      let l:matches = matchlist(l:line, '\\bibitem\(\[[^]]\]\)\?{\([^}]*\)')
      if len(l:matches) > 1
        call add(l:res, {
              \ 'key': l:matches[2],
              \ 'type': 'thebibliography',
              \ 'author': '',
              \ 'year': '',
              \ 'title': l:matches[2],
              \ })
      endif
    endfor
  endif

  return l:res
endfunction

" }}}1
" {{{1 Labels

let s:completer_ref = {
      \ 'patterns' : [
      \   '\v\\v?%(auto|eq|[cC]?%(page)?|labelc)?ref%(\s*\{[^}]*|range\s*\{[^,{}]*%(\}\{)?)$',
      \   '\\hyperref\s*\[[^]]*$',
      \   '\\subref\*\?{[^}]*$',
      \ ],
      \ 're_context' : '\\\w*{[^}]*$',
      \ 'cache' : {},
      \ 'labels' : [],
      \ 'initialized' : 0,
      \}

function! s:completer_ref.init() dict abort " {{{2
  if self.initialized | return | endif
  let self.initialized = 1

  " Add custom patterns
  let self.patterns += g:vimtex_complete_ref.custom_patterns
endfunction

function! s:completer_ref.complete(regex) dict abort " {{{2
  let self.candidates = self.get_matches(a:regex)

  if self.context =~# '\\eqref'
        \ && !empty(filter(copy(self.matches), 'v:val.word =~# ''^eq:'''))
    call filter(self.candidates, 'v:val.word =~# ''^eq:''')
  endif

  return self.candidates
endfunction

function! s:completer_ref.get_matches(regex) dict abort " {{{2
  call self.parse_aux_files()

  " Match number
  let self.matches = filter(copy(self.labels), 'v:val.menu =~# ''' . a:regex . '''')
  if !empty(self.matches) | return self.matches | endif

  " Match label
  let self.matches = filter(copy(self.labels), 'v:val.word =~# ''' . a:regex . '''')

  " Match label and number
  if empty(self.matches)
    let l:regex_split = split(a:regex)
    if len(l:regex_split) > 1
      let l:base = l:regex_split[0]
      let l:number = escape(join(l:regex_split[1:], ' '), '.')
      let self.matches = filter(copy(self.labels),
            \ 'v:val.word =~# ''' . l:base   . ''' &&' .
            \ 'v:val.menu =~# ''' . l:number . '''')
    endif
  endif

  return self.matches
endfunction

function! s:completer_ref.parse_aux_files() dict abort " {{{2
  let l:files = [[b:vimtex.aux(), '']]

  " Handle local file editing (e.g. subfiles package)
  if exists('b:vimtex_local') && b:vimtex_local.active
    let l:files += [[vimtex#state#get(b:vimtex_local.main_id).aux(), '']]
  endif

  " Add externaldocuments (from \externaldocument in preamble)
  let l:files += map(
        \ vimtex#parser#get_externalfiles(),
        \ '[v:val.aux, v:val.opt]')

  let self.labels = []
  for [l:file, l:prefix] in filter(l:files, 'filereadable(v:val[0])')
    let l:cached = get(self.cache, l:file, {})
    if get(l:cached, 'ftime', 0) != getftime(l:file)
      let l:cached.ftime = getftime(l:file)
      let l:cached.labels = self.parse_labels(l:file, l:prefix)
      let self.cache[l:file] = l:cached
    endif

    let self.labels += l:cached.labels
  endfor

  return self.labels
endfunction

function! s:completer_ref.parse_labels(file, prefix) dict abort " {{{2
  "
  " Searches aux files recursively for commands of the form
  "
  "   \newlabel{name}{{number}{page}.*}.*
  "   \newlabel{name}{{text {number}}{page}.*}.*
  "   \newlabel{name}{{number}{page}{...}{type}.*}.*
  "
  " Returns a list of candidates like {'word': name, 'menu': type number page}.
  "

  let l:labels = []
  let l:lines = vimtex#parser#aux(a:file)
  let l:lines = filter(l:lines, 'v:val =~# ''\\newlabel{''')
  let l:lines = filter(l:lines, 'v:val !~# ''@cref''')
  let l:lines = filter(l:lines, 'v:val !~# ''sub@''')
  let l:lines = filter(l:lines, 'v:val !~# ''tocindent-\?[0-9]''')
  for l:line in l:lines
    let l:line = vimtex#util#tex2unicode(l:line)
    let l:tree = vimtex#util#tex2tree(l:line)[1:]
    let l:name = get(remove(l:tree, 0), 0, '')
    if empty(l:name)
      continue
    else
      let l:name = a:prefix . l:name
    endif
    let l:context = remove(l:tree, 0)
    if type(l:context) == type([]) && len(l:context) > 1
      let l:menu = ''
      try
        let l:type = substitute(l:context[3][0], '\..*$', ' ', '')
        let l:type = substitute(l:type, 'AMS', 'Equation', '')
        let l:menu .= toupper(l:type[0]) . l:type[1:]
      catch
      endtry

      let l:number = self.parse_number(l:context[0])
      if l:menu =~# 'Equation'
        let l:number = '(' . l:number . ')'
      endif
      let l:menu .= l:number

      try
        let l:menu .= ' [p. ' . l:context[1][0] . ']'
      catch
      endtry
      call add(l:labels, {'word': l:name, 'menu': l:menu})
    endif
  endfor

  return l:labels
endfunction

function! s:completer_ref.parse_number(num_tree) dict abort " {{{2
  if type(a:num_tree) == type([])
    if len(a:num_tree) == 0
      return '-'
    else
      let l:index = len(a:num_tree) == 1 ? 0 : 1
      return self.parse_number(a:num_tree[l:index])
    endif
  else
    let l:matches = matchlist(a:num_tree, '\v(^|.*\s)((\u|\d+)(\.\d+)*\l?)($|\s.*)')
    return len(l:matches) > 3 ? l:matches[2] : '-'
  endif
endfunction

" }}}1
" {{{1 Commands

let s:completer_cmd = {
      \ 'patterns' : [g:vimtex#re#not_bslash . '\\\a*$'],
      \ 'candidates_from_packages' : [],
      \ 'candidates_from_newcommands' : [],
      \ 'candidates_from_lets' : [],
      \ 'candidates_from_glossary_keys' : [],
      \ 'inside_braces' : 0,
      \}

function! s:completer_cmd.complete(regex) dict abort " {{{2
  let l:candidates = self.gather_candidates()
  let l:mode = vimtex#util#in_mathzone() ? 'm' : 'n'

  call s:filter_with_options(l:candidates, a:regex)
  call filter(l:candidates, 'l:mode =~# v:val.mode')

  return l:candidates
endfunction

function! s:completer_cmd.gather_candidates() dict abort " {{{2
  call self.gather_candidates_from_packages()
  call self.gather_candidates_from_newcommands()
  call self.gather_candidates_from_lets()
  call self.gather_candidates_from_glossary_keys()

  return vimtex#util#uniq_unsorted(
        \   copy(self.candidates_from_newcommands)
        \ + copy(self.candidates_from_lets)
        \ + copy(self.candidates_from_packages)
        \ + copy(self.candidates_from_glossary_keys))
endfunction

function! s:completer_cmd.gather_candidates_from_packages() dict abort " {{{2
  let l:packages = [
        \ 'default',
        \ 'class-' . get(b:vimtex, 'documentclass', ''),
        \] + keys(b:vimtex.packages)
  call s:load_candidates_from_packages(l:packages)

  let self.candidates_from_packages = []
  for l:p in l:packages
    let self.candidates_from_packages += get(
          \ get(s:candidates_from_packages, l:p, {}), 'commands', [])
  endfor
endfunction

function! s:completer_cmd.gather_candidates_from_newcommands() dict abort " {{{2
  " Simple caching
  if !empty(self.candidates_from_newcommands)
    let l:modified_time = max(map(
          \ copy(get(b:vimtex, 'source_files', [b:vimtex.tex])),
          \ 'getftime(v:val)'))
    if l:modified_time > get(self, 'newcommands_updated')
      let self.newcommands_updated = l:modified_time
    else
      return
    endif
  endif

  let l:candidates = vimtex#parser#tex(b:vimtex.tex, {'detailed' : 0})

  " catch commands defined by xparse and standard declaration
  call filter(l:candidates, 'v:val =~# ''\v\\((provide|renew|new)command|(New|Declare|Provide|Renew)(Expandable)?DocumentCommand)''')
  call map(l:candidates, '{
        \ ''word'' : matchstr(v:val, ''\v\\((provide|renew|new)command|(New|Declare|Provide|Renew)(Expandable)?DocumentCommand)\*?\{\\?\zs[^}]*''),
        \ ''mode'' : ''.'',
        \ ''kind'' : ''[cmd: newcommand]'',
        \ }')

  let self.candidates_from_newcommands = l:candidates
endfunction

function! s:completer_cmd.gather_candidates_from_glossary_keys() dict abort " {{{2
  if !has_key(b:vimtex.packages, 'glossaries') | return | endif

  let l:preamble = vimtex#parser#tex(b:vimtex.tex, {
        \ 're_stop': '\\begin{document}',
        \ 'detailed': 0,
        \})
  call map(l:preamble, "substitute(v:val, '\\s*%.*', '', 'g')")
  let l:glskeys = split(join(l:preamble, "\n"), '\n\s*\\glsaddkey\*\?')[1:]
  call map(l:glskeys, "substitute(v:val, '\n\\s*', '', 'g')")
  call map(l:glskeys, 'vimtex#util#tex2tree(v:val)[2:6]')

  let l:candidates = map(vimtex#util#flatten(l:glskeys), '{
        \ ''word'' : v:val[1:],
        \ ''mode'' : ''.'',
        \ ''kind'' : ''[cmd: glossaries]'',
        \ }')

  let self.candidates_from_glossary_keys = l:candidates
endfunction

function! s:completer_cmd.gather_candidates_from_lets() dict abort " {{{2
  let l:preamble = vimtex#parser#tex(b:vimtex.tex, {
        \ 're_stop': '\\begin{document}',
        \ 'detailed': 0,
        \})

  let l:lets = filter(copy(l:preamble), 'v:val =~# ''\\let\>''')
  let l:defs = filter(copy(l:preamble), 'v:val =~# ''\\def\>''')
  let l:candidates = map(l:lets, '{
        \ ''word'' : matchstr(v:val, ''\\let[^\\]*\\\zs\w*''),
        \ ''mode'' : ''.'',
        \ ''kind'' : ''[cmd: \let]'',
        \ }')
        \ + map(l:defs, '{
        \ ''word'' : matchstr(v:val, ''\\def[^\\]*\\\zs\w*''),
        \ ''mode'' : ''.'',
        \ ''kind'' : ''[cmd: \def]'',
        \ }')

  let self.candidates_from_lets = l:candidates
endfunction

" }}}1
" {{{1 Filenames (\includegraphics)

let s:completer_img = {
      \ 'patterns' : ['\v\\includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*$'],
      \ 'ext_re' : '\v\.%('
      \   . join(['png', 'jpg', 'eps', 'pdf', 'pgf', 'tikz'], '|')
      \   . ')$',
      \}

function! s:completer_img.complete(regex) dict abort " {{{2
  return s:filter_with_options(self.gather_candidates(), a:regex)
endfunction

function! s:completer_img.gather_candidates() dict abort " {{{2
  let l:added_files = []
  let l:generated_pdf = b:vimtex.out()

  let l:candidates = []
  for l:path in b:vimtex.graphicspath + [b:vimtex.root]
    let l:files = globpath(l:path, '**/*.*', 1, 1)

    call filter(l:files, 'v:val =~? self.ext_re')
    call filter(l:files, 'v:val !=# l:generated_pdf')
    call filter(l:files, 'index(l:added_files, v:val) < 0')

    let l:added_files += l:files
    let l:candidates += map(l:files, "{
            \ 'abbr': vimtex#paths#shorten_relative(v:val),
            \ 'word': vimtex#paths#relative(v:val, l:path),
            \ 'kind': '[graphics]',
            \}")
  endfor

  return l:candidates
endfunction

" }}}1
" {{{1 Filenames (\input, \include, and \subfile)

let s:completer_inc = {
      \ 'patterns' : [
      \   g:vimtex#re#tex_input . '[^}]*$',
      \   '\v\\includeonly\s*\{[^}]*$',
      \ ],
      \}

function! s:completer_inc.complete(regex) dict abort " {{{2
  let self.candidates = split(globpath(b:vimtex.root, '**/*.tex'), '\n')
  let self.candidates = map(self.candidates,
        \ 'strpart(v:val, len(b:vimtex.root)+1)')
  call s:filter_with_options(self.candidates, a:regex)

  if self.context =~# '\\include'
    let self.candidates = map(self.candidates, '{
          \ ''word'' : fnamemodify(v:val, '':r''),
          \ ''kind'' : '' [include]'',
          \}')
  else
    let self.candidates = map(self.candidates, '{
          \ ''word'' : v:val,
          \ ''kind'' : '' [input]'',
          \}')
  endif

  return self.candidates
endfunction

" }}}1
" {{{1 Filenames (\includepdf)

let s:completer_pdf = {
      \ 'patterns' : ['\v\\includepdf%(\s*\[[^]]*\])?\s*\{[^}]*$'],
      \}

function! s:completer_pdf.complete(regex) dict abort " {{{2
  let self.candidates = split(globpath(b:vimtex.root, '**/*.pdf'), '\n')
  let self.candidates = map(self.candidates,
        \ 'strpart(v:val, len(b:vimtex.root)+1)')
  call s:filter_with_options(self.candidates, a:regex)
  let self.candidates = map(self.candidates, '{
        \ ''word'' : v:val,
        \ ''kind'' : '' [includepdf]'',
        \}')
  return self.candidates
endfunction

" }}}1
" {{{1 Filenames (\includestandalone)

let s:completer_sta = {
      \ 'patterns' : ['\v\\includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*$'],
      \}

function! s:completer_sta.complete(regex) dict abort " {{{2
  let self.candidates = substitute(globpath(b:vimtex.root, '**/*.tex'), '\.tex', '', 'g')
  let self.candidates = split(self.candidates, '\n')
  let self.candidates = map(self.candidates,
        \ 'strpart(v:val, len(b:vimtex.root)+1)')
  call s:filter_with_options(self.candidates, a:regex)
  let self.candidates = map(self.candidates, '{
        \ ''word'' : v:val,
        \ ''kind'' : '' [includestandalone]'',
        \}')
  return self.candidates
endfunction

" }}}1
" {{{1 Glossary

let s:completer_gls = {
      \ 'patterns' : [
      \   '\v\\([cpdr]?(gls|Gls|GLS)|acr|Acr|ACR)\a*\s*\{[^}]*$',
      \   '\v\\(ac|Ac|AC)\s*\{[^}]*$',
      \ ],
      \ 'key' : {
      \   'newglossaryentry' : ' [gls]',
      \   'longnewglossaryentry' : ' [gls]',
      \   'newacronym' : ' [acr]',
      \   'newabbreviation' : ' [abbr]',
      \   'glsxtrnewsymbol' : ' [symbol]',
      \ },
      \}

function! s:completer_gls.init() dict abort " {{{2
  if !has_key(b:vimtex.packages, 'glossaries-extra') | return | endif

  " Detect stuff like this:
  "  \GlsXtrLoadResources[src=glossary.bib]
  "  \GlsXtrLoadResources[src={glossary.bib}, selection={all}]
  "  \GlsXtrLoadResources[selection={all},src={glossary.bib}]
  "  \GlsXtrLoadResources[
  "    src={glossary.bib},
  "    selection={all},
  "  ]

  let l:do_search = 0
  for l:line in vimtex#parser#tex(b:vimtex.tex, {
        \ 're_stop': '\\begin{document}',
        \ 'detailed': 0,
        \})
    if line =~# '^\s*\\GlsXtrLoadResources\s*\['
      let l:do_search = 1
      let l:line = matchstr(l:line, '^\s*\\GlsXtrLoadResources\s*\[\zs.*')
    endif
    if !l:do_search | continue | endif

    let l:matches = split(l:line, '[=,]')
    if empty(l:matches) | continue | endif

    while !empty(l:matches)
      let l:key = vimtex#util#trim(remove(l:matches, 0))
      if l:key ==# 'src'
        let l:value = vimtex#util#trim(remove(l:matches, 0))
        let l:value = substitute(l:value, '^{', '', '')
        let l:value = substitute(l:value, '[]}]\s*', '', 'g')
        let b:vimtex.complete.glsbib = l:value
        break
      endif
    endwhile
  endfor
endfunction

function! s:completer_gls.complete(regex) dict abort " {{{2
  return s:filter_with_options(
        \ self.parse_glsentries() + self.parse_glsbib(), a:regex)
endfunction

function! s:completer_gls.parse_glsentries() dict abort " {{{2
  let l:candidates = []

  let l:re_input = g:vimtex#re#tex_input . '|^\s*\\loadglsentries'
  let l:re_commands = '\v\\(' . join(keys(self.key), '|') . ')'
  let l:re_matcher = l:re_commands . '\s*%(\[.*\])=\s*\{([^{}]*)'

  for l:line in filter(vimtex#parser#tex(b:vimtex.tex, {
        \   'detailed' : 0,
        \   'input_re' : l:re_input,
        \ }), 'v:val =~# l:re_commands')
    let l:matches = matchlist(l:line, l:re_matcher)
    call add(l:candidates, {
          \ 'word' : l:matches[2],
          \ 'menu' : self.key[l:matches[1]],
          \})
  endfor

  return l:candidates
endfunction

function! s:completer_gls.parse_glsbib() dict abort " {{{2
  let l:filename = get(b:vimtex.complete, 'glsbib', '')
  if empty(l:filename) | return [] | endif

  let l:candidates = []
  for l:entry in vimtex#parser#bib(l:filename, {'backend': 'bibparse'})
    call add(l:candidates, {
          \ 'word': l:entry.key,
          \ 'menu': get(l:entry, 'name', '--'),
          \})
  endfor

  return l:candidates
endfunction

" }}}1
" {{{1 Packages (\usepackage)

let s:completer_pck = {
      \ 'patterns' : [
      \   '\v\\%(usepackage|RequirePackage)%(\s*\[[^]]*\])?\s*\{[^}]*$',
      \   '\v\\PassOptionsToPackage\s*\{[^}]*\}\s*\{[^}]*$',
      \ ],
      \ 'candidates' : [],
      \}

function! s:completer_pck.complete(regex) dict abort " {{{2
  return s:filter_with_options(self.gather_candidates(), a:regex)
endfunction

function! s:completer_pck.gather_candidates() dict abort " {{{2
  if empty(self.candidates)
    let self.candidates = map(s:get_texmf_candidates('sty'), '{
          \ ''word'' : v:val,
          \ ''kind'' : '' [package]'',
          \}')
  endif

  return copy(self.candidates)
endfunction

" }}}1
" {{{1 Documentclasses (\documentclass)

let s:completer_doc = {
      \ 'patterns' : ['\v\\documentclass%(\s*\[[^]]*\])?\s*\{[^}]*$'],
      \ 'candidates' : [],
      \}

function! s:completer_doc.complete(regex) dict abort " {{{2
  return s:filter_with_options(self.gather_candidates(), a:regex)
endfunction

function! s:completer_doc.gather_candidates() dict abort " {{{2
  if empty(self.candidates)
    let self.candidates = map(s:get_texmf_candidates('cls'), '{
          \ ''word'' : v:val,
          \ ''kind'' : '' [documentclass]'',
          \}')
  endif

  return copy(self.candidates)
endfunction

" }}}1
" {{{1 Environments (\begin/\end)

let s:completer_env = {
      \ 'patterns' : ['\v\\%(begin|end)%(\s*\[[^]]*\])?\s*\{[^}]*$'],
      \ 'candidates_from_newenvironments' : [],
      \ 'candidates_from_packages' : [],
      \}

function! s:completer_env.complete(regex) dict abort " {{{2
  if self.context =~# '^\\end\>'
    " When completing \end{, search for an unmatched \begin{...}
    let l:matching_env = ''
    let l:save_pos = vimtex#pos#get_cursor()
    let l:pos_val_cursor = vimtex#pos#val(l:save_pos)

    let l:lnum = l:save_pos[1] + 1
    while l:lnum > 1
      let l:open  = vimtex#delim#get_prev('env_tex', 'open')
      if empty(l:open) || get(l:open, 'name', '') ==# 'document'
        break
      endif

      let l:close = vimtex#delim#get_matching(l:open)
      if empty(l:close.match)
        let l:matching_env = l:close.name . (l:close.starred ? '*' : '')
        break
      endif

      let l:pos_val_try = vimtex#pos#val(l:close) + strlen(l:close.match)
      if l:pos_val_try > l:pos_val_cursor
        break
      else
        let l:lnum = l:open.lnum
        call vimtex#pos#set_cursor(vimtex#pos#prev(l:open))
      endif
    endwhile

    call vimtex#pos#set_cursor(l:save_pos)

    if !empty(l:matching_env) && l:matching_env =~# a:regex
      return [{
            \ 'word': l:matching_env,
            \ 'kind': '[env: matching]',
            \}]
    endif
  endif

  return s:filter_with_options(copy(self.gather_candidates()), a:regex)
endfunction

" }}}2
function! s:completer_env.gather_candidates() dict abort " {{{2
  call self.gather_candidates_from_packages()
  call self.gather_candidates_from_newenvironments()

  return vimtex#util#uniq_unsorted(
        \   copy(self.candidates_from_newenvironments)
        \ + copy(self.candidates_from_packages))
endfunction

" }}}2
function! s:completer_env.gather_candidates_from_packages() dict abort " {{{2
  let l:packages = [
        \ 'default',
        \ 'class-' . get(b:vimtex, 'documentclass', ''),
        \] + keys(b:vimtex.packages)
  call s:load_candidates_from_packages(l:packages)

  let self.candidates_from_packages = []
  for l:p in l:packages
    let self.candidates_from_packages += get(
          \ get(s:candidates_from_packages, l:p, {}), 'environments', [])
  endfor
endfunction

" }}}2
function! s:completer_env.gather_candidates_from_newenvironments() dict abort " {{{2
  " Simple caching
  if !empty(self.candidates_from_newenvironments)
    let l:modified_time = max(map(
          \ copy(get(b:vimtex, 'source_files', [b:vimtex.tex])),
          \ 'getftime(v:val)'))
    if l:modified_time > get(self, 'newenvironments_updated')
      let self.newenvironments_updated = l:modified_time
    else
      return
    endif
  endif

  let l:candidates = vimtex#parser#tex(b:vimtex.tex, {'detailed' : 0})

  call filter(l:candidates, 'v:val =~# ''\v\\((renew|new)environment|(New|Renew|Provide|Declare)DocumentEnvironment)''')
  call map(l:candidates, '{
        \ ''word'' : matchstr(v:val, ''\v\\((renew|new)environment|(New|Renew|Provide|Declare)DocumentEnvironment)\*?\{\\?\zs[^}]*''),
        \ ''mode'' : ''.'',
        \ ''kind'' : ''[env: newenvironment]'',
        \ }')

  let self.candidates_from_newenvironments = l:candidates
endfunction

" }}}1
" {{{1 Bibliographystyles (\bibliographystyle)

let s:completer_bst = {
      \ 'patterns' : ['\v\\bibliographystyle\s*\{[^}]*$'],
      \ 'candidates' : [],
      \}

function! s:completer_bst.complete(regex) dict abort " {{{2
  return s:filter_with_options(self.gather_candidates(), a:regex)
endfunction

function! s:completer_bst.gather_candidates() dict abort " {{{2
  if empty(self.candidates)
    let self.candidates = map(s:get_texmf_candidates('bst'), '{
          \ ''word'' : v:val,
          \ ''kind'' : '' [bst files]'',
          \}')
  endif

  return copy(self.candidates)
endfunction

" }}}1

"
" Utility functions
"
function! s:filter_with_options(input, regex, ...) abort " {{{1
  if empty(a:input) | return a:input | endif

  let l:opts = a:0 > 0 ? a:1 : {}
  let l:expression = type(a:input[0]) == type({})
        \ ? get(l:opts, 'filter_by_menu') ? 'v:val.menu' : 'v:val.word'
        \ : 'v:val'

  if g:vimtex_complete_ignore_case && (!g:vimtex_complete_smart_case || a:regex !~# '\u')
    let l:expression .= ' =~? '
  else
    let l:expression .= ' =~# '
  endif

  if get(l:opts, 'anchor', 1)
    let l:expression .= '''^'' . '
  endif

  let l:expression .= 'a:regex'

  return filter(a:input, l:expression)
endfunction

" }}}1
function! s:get_texmf_candidates(filetype) abort " {{{1
  let l:candidates = []

  let l:texmfhome = $TEXMFHOME
  if empty(l:texmfhome)
    let l:texmfhome = get(vimtex#kpsewhich#run('--var-value TEXMFHOME'), 0, '')
  endif

  " Add locally installed candidates first
  if !empty(l:texmfhome)
    let l:candidates += glob(l:texmfhome . '/**/*.' . a:filetype, 0, 1)
    call map(l:candidates, 'fnamemodify(v:val, '':t:r'')')
  endif

  " Then add globally available candidates (based on ls-R files)
  for l:file in vimtex#kpsewhich#run('--all ls-R')
    let l:candidates += map(filter(readfile(l:file),
          \   'v:val =~# ''\.' . a:filetype . ''''),
          \ 'fnamemodify(v:val, '':r'')')
  endfor

  return l:candidates
endfunction

" }}}1
function! s:load_candidates_from_packages(packages) abort " {{{1
  let l:packages = filter(copy(a:packages),
        \ '!has_key(s:candidates_from_packages, v:val)')
  if empty(l:packages) | return | endif

  call vimtex#paths#pushd(s:complete_dir)

  for l:unreadable in filter(copy(l:packages), '!filereadable(v:val)')
    let s:candidates_from_packages[l:unreadable] = {}
    call remove(l:packages, index(l:packages, l:unreadable))
  endfor

  let l:queue = copy(l:packages)
  while !empty(l:queue)
    let l:current = remove(l:queue, 0)
    let l:includes = filter(readfile(l:current), 'v:val =~# ''^\#\s*include:''')
    if empty(l:includes) | continue | endif

    call map(l:includes, 'matchstr(v:val, ''include:\s*\zs.*\ze\s*$'')')
    call filter(l:includes, 'filereadable(v:val)')
    call filter(l:includes, 'index(l:packages, v:val) < 0')

    let l:packages += l:includes
    let l:queue += l:includes
  endwhile

  for l:package in l:packages
    let s:candidates_from_packages[l:package] = {
          \ 'commands':     [],
          \ 'environments': [],
          \}

    let l:lines = readfile(l:package)

    let l:candidates = filter(copy(l:lines), 'v:val =~# ''^\a''')
    call map(l:candidates, 'split(v:val)')
    call map(l:candidates, '{
          \ ''word'' : v:val[0],
          \ ''mode'' : ''.'',
          \ ''kind'' : ''[cmd: '' . l:package . ''] '',
          \ ''menu'' : (get(v:val, 1, '''')),
          \}')
    let s:candidates_from_packages[l:package].commands += l:candidates

    let l:candidates = filter(copy(l:lines), 'v:val =~# ''^\\begin{''')
    call map(l:candidates, '{
          \ ''word'' : substitute(v:val, ''^\\begin{\|}$'', '''', ''g''),
          \ ''mode'' : ''.'',
          \ ''kind'' : ''[env: '' . l:package . ''] '',
          \}')
    let s:candidates_from_packages[l:package].environments += l:candidates
  endfor

  call vimtex#paths#popd()
endfunction

let s:candidates_from_packages = {}

" }}}1
function! s:close_braces(candidates) abort " {{{1
  if strpart(getline('.'), col('.') - 1) !~# '^\s*[,}]'
    for l:cand in a:candidates
      if !has_key(l:cand, 'abbr')
        let l:cand.abbr = l:cand.word
      endif
      let l:cand.word = substitute(l:cand.word, '}*$', '}', '')
    endfor
  endif

  return a:candidates
endfunction

" }}}1


" {{{1 Initialize module

let s:completers = map(
      \ filter(items(s:), 'v:val[0] =~# ''^completer_'''),
      \ 'v:val[1]')

let s:complete_dir = fnamemodify(expand('<sfile>'), ':r') . '/'

" }}}1

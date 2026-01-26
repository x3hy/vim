let mapleader = "\\"

" Restore last colorscheme on startup
autocmd VimEnter * nested
    \ if !empty(get(g:, 'LAST_COLORSCHEME', '')) |
    \   try | exe 'colorscheme' g:LAST_COLORSCHEME | catch | endtry |
    \ endif

" Plugins
call plug#begin()
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ap/vim-buftabline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" Lsp
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Movement
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>j
nnoremap <Leader>j <C-w>k
nnoremap <Leader>k <C-w>l

nnoremap <C-h> :vertical resize -2<CR>
nnoremap <C-l> :vertical resize +2<CR>
nnoremap <C-j> :resize -2<CR>
nnoremap <C-k> :resize +2<CR>

" Buffers1
nnoremap <Leader>d :bnext<CR>
nnoremap <Leader>a :bprev<CR>

" Basic options
set nu
set rnu
set mouse=a
set nowrap
set shiftwidth=4
set tabstop=4
set cursorline
set showtabline=1
set foldcolumn=3
set completeopt=menuone,noinsert,noselect,preview
set nocompatible
set shellslash
set wildmenu
set wildmode=longest:full,full
set wildoptions=pum
set foldmethod=syntax
set foldlevelstart=99
set hidden
set noswapfile

set backupdir=.vbackup
if !isdirectory('.vbackup')
    silent! execute '!mkdir -p .vbackup'
endif

set undodir=.vundo
if !isdirectory('.vundo')
    silent! execute '!mkdir -p .vundo'
endif

set writebackup
set undofile
set backup


" Statusline
set laststatus=2
set showcmd
set noshowmode
set cmdheight=1

function! FileSize(bytes)
  let l:bytes = a:bytes | let l:sizes = ['B', 'KB', 'MB', 'GB'] | let l:i = 0
  while l:bytes >= 1024 | let l:bytes = l:bytes / 1024.0 | let l:i += 1 | endwhile
  return l:bytes > 0 ? printf('%.2f%s ', l:bytes, l:sizes[l:i]) : ''
endfunction

set statusline+=%<\ [%{mode()}]\ \|\ %F\ \|\ %y\ \|\ %{FileSize(line2byte('$')+len(getline('$')))}\ %h%m%r%=%-14.(%l/%L,\ %c%V%)\ --%P--\ 

" Ruler for line size
" set colorcolumn=80
" highlight ColorColumn ctermbg=white

filetype plugin indent on
syntax on

" Yazi intergration
function LaunchYazi()
    let tempname = tempname()
    execute 'silent !bash -c "TERM=xterm-kitty yazi --chooser-file ' .. tempname .. '"'
    redraw!

    if filereadable(tempname)
        let paths = readfile(tempname)
        call delete(tempname)

        if empty(paths)
            return
        endif

        execute 'edit' fnameescape(paths[0])

        for path in paths[1:]
            execute 'vsplit' fnameescape(path)
        endfor
    endif
endfunction

command! YaziLaunch call LaunchYazi()
nnoremap <leader>ef :YaziLaunch<CR>

command! YaziLaunch call LaunchYazi()
nnoremap <Leader>ef :YaziLaunch<CR>

" FZF command uses fg for max speed
let g:rg_command = 'rg --vimgrep --smart-case'

" Use built-in colorscheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Basic binds
nnoremap <C-e> :FZF<CR>
nnoremap <C-g> :Colors<CR>
nnoremap <tab> :Buffers<CR>

" Reload vim config on <Leader>ee
nnoremap <Leader>e :source ~/.vim/vimrc<CR>

" Save colorscheme
set viminfo^=!


" Remember colorscheme every time it changes
autocmd ColorScheme * let g:LAST_COLORSCHEME = expand('<amatch>')

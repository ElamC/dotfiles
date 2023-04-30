set relativenumber number
set tabstop=4
set autoindent
set smartindent
set incsearch
set hlsearch
set clipboard+=unnamedplus
set mouse=a
set nocompatible
set scrolloff=10
set ignorecase smartcase
set path+=**
set showmode
set showcmd
set inccommand=nosplit
set colorcolumn=80
syntax enable
let mapleader=" "

call plug#begin('~/.config/nvim/autoload/plugged')

Plug 'tpope/vim-surround'
Plug 'chaoren/vim-wordmotion'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'svermeulen/vim-subversive'

call plug#end()

au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=200}

" inner entire buffer
onoremap ib :exec "normal! ggVG"<cr>
vmap <leader>s <plug>(SubversiveSubstituteRange)
nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

" vscode
nnoremap <leader>p <Cmd>call VSCodeNotify('workbench.action.showCommands')<CR>
nnoremap <leader>b <Cmd>call VSCodeNotify('editor.debug.action.toggleBreakpoint')<CR>
nnoremap <leader>f <Cmd>call VSCodeNotify('workbench.action.findInFiles', {'query': expand('<cword>'), 'replace': ''})<CR>

xmap <leader>/ <Plug>Commentary
nmap <leader>/ <Plug>Commentary
omap <leader>/ <Plug>Commentary

" inoremap kj <Esc>
noremap <Esc> <nop>
nnoremap <space> <nop>

" jump to line start/end in insert mode
inoremap <C-a> <Esc>A
inoremap <C-i> <Esc>I

" Toggle current and last buffer
" nnoremap <leader><Tab> :b# <CR>

" switch to last used tab
nmap <leader><Tab> <C-^>

" end of line without switching to insert mode
inoremap <C-e> <C-o>A
" yank to end of line
nmap Y y$

nmap Q gq
nmap <leader>kb ;q<CR>

" switch to last used tab
nmap <leader><Tab> <C-^>

nmap <Tab> gt

" new line without entering insert mode
nnoremap o o<Esc>
nnoremap O O<Esc>

" set mark in register z, join and go to mark
nnoremap J mzJ`z

nnoremap dd "_dd
vnoremap d "_d
nnoremap n nzz
nnoremap N Nzz

" size split
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap q <C-v>

" Greatest remap EVER!!
" delete and yank selected to VOID register
" replace with register content
vnoremap <leader>p "_dP

vnoremap > >gv
vnoremap < <gv
map - <C-W>-
map + <C-W>

" jump to first non-blank-character in line
map 0 ^

nnoremap ; :
nnoremap . ;

" new empty buffer
nmap <leader>t :enew<CR>

nmap <leader>/ :noh<CR>

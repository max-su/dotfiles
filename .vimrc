call plug#begin('~/.vim/plugged')
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'morhetz/gruvbox'
    Plug 'w0rp/ale'
    Plug 'tpope/vim-commentary'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Set vim to move the swapfiles elsewhere
set directory=$HOME/.vim/swapfiles//

" Toggle paste mode
set pastetoggle=<F2>

" [*] seoul256 Background [*]
set background=dark
colorscheme gruvbox

" [*] Tabs & Numbers & Backspaces [*]
filetype plugin indent on
" Show existing tab with 4 spaces width.
set tabstop=4
" When indenting with '>', use 4 spaces width.
set shiftwidth=4
" On pressing tab, insert 4 spaces.
set expandtab

" [*] Usability [*]
" Add line numbers to vim.
set number
" https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode
set backspace=indent,eol,start
" Show trailing spaces in vim
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" [*] vim-airline config [*]
set laststatus=2
set ttimeoutlen=50
let g:airline_theme='gruvbox'

" Set this. Airline will handle the rest. Show errors or warnings in my status
" line
let g:airline#extensions#ale#enabled = 1


" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
        au! auto_highlight
        augroup! auto_highlight
        setl updatetime=4000
        echo 'Highlight current word: off'
        return 0
    else
        augroup auto_highlight
            au!
            au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
        augroup end
        setl updatetime=500
        echo 'Highlight current word: ON'
        return 1
    endif
endfunction

" Set vim to to transparent background
hi Normal guibg=NONE ctermbg=NONE

" Ale config
let g:ale_linters = {'rust': ['cargo'], 'python': ['flake8']}
let g:ale_rust_rls_toolchain = 'stable'

" map ; :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))<Enter>
nmap ; :GFiles<Enter>
nnoremap <C-f> :Files<Enter>
nnoremap <C-y> gg"*yG
set pastetoggle=<F2>

" https://stackoverflow.com/a/9449010
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>

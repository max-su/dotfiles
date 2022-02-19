call plug#begin('~/.vim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'josa42/vim-lightline-coc'
    Plug 'itchyny/lightline.vim'
    Plug 'shinchu/lightline-gruvbox.vim'
call plug#end()

" Enable Gruvbox Colorscheme
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

" Move the swapfiles elsewhere
set directory=$HOME/.vim/swapfiles//

" [*] Usability [*]
" Add line numbers to vim.
set number
" https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode
set backspace=indent,eol,start
" Show trailing spaces in vim
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
set pastetoggle=<F2>

filetype plugin indent on
" Show existing tab with 4 spaces width
set tabstop=4
" When indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" [*] fzf bindings [*]
nnoremap <leader><leader> :GFiles<CR>
nnoremap <leader>f       :Files<CR>
nnoremap <leader>l       :Lines<CR>
nnoremap <leader>a       :Ag!<CR>

" [*] vim-fugitive bindings [*]
nnoremap <leader>ga       :Git add .<CR>
nnoremap <leader>gc       :Git commit<CR>

" [*] lightline config [*]
" 2 sets it to always display the status bar
set laststatus=2
" Tells Vim to only wait 50ms for a sequence of keycodes to finish
set ttimeoutlen=50

let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'
let g:lightline = {
  \   'active': {
  \     'left': [[  'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' ], [ 'coc_status'  ], ['absolutepath']]
  \   }
  \ }
" register compoments
call lightline#coc#register()

" [*] Cute functions to make my life easier [*]
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

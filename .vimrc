" ////////////////////////////////////////////////////////////
" basic
" ////////////////////////////////////////////////////////////

set nocompatible " be iMproved, required
let mapleader=","

" always use English menu
" NOTE: this must before filetype off, otherwise it won't work
set langmenu=none

" use Englisth for anything in vim-editor
silent exec 'language en_US.utf8'

" set defualt encoding to utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set encoding=utf-8
set termencoding=utf-8

" ////////////////////////////////////////////////////////////
" Bundle setup
" ////////////////////////////////////////////////////////////

filetype off " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
let vimrc_plugins_path = '.vimrc_plugins_liy'
" load .vimrc.plugins
if filereadable(expand(vimrc_plugins_path))
    exec 'source ' . fnameescape(vimrc_plugins_path)
endif
call vundle#end()
filetype plugin indent on " required
syntax on " required


" ////////////////////////////////////////////////////////////
" Default colorscheme setup
" ////////////////////////////////////////////////////////////
syntax enable
syntax on
if has('gui_running')
    set background=dark
else
    set background=dark
    set t_Co=256 " make sure our terminal use 256 color
endif

colorscheme molokai
"colorscheme solarized 
colorscheme desert
" colorscheme solarized 



" ////////////////////////////////////////////////////////////
" General
" ////////////////////////////////////////////////////////////

" setup back and swap directory
set history=1000 " keep 1000 lines of command line history
set autoread " auto read same-file change (better for vc/vim change)
set maxmempattern=1000 " enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)

" ////////////////////////////////////////////////////////////
" xterm settings
" ////////////////////////////////////////////////////////////
behave xterm " set mouse behavior as xterm
if &term =~ 'xterm'
    set mouse=a
endif

" ////////////////////////////////////////////////////////////
" Variable settings (set all)
" ////////////////////////////////////////////////////////////
set matchtime=0 " 0 second to show the matching paren (much fater)
set nu " show line number
set scrolloff=0 " minimal number of screen lines to keep above and below the cursor
" set nowrap " do not warp text
set wrap
" only support in 7.3 or higher
if v:version >= 703
    set noacd " no autochchdir
endif

" ////////////////////////////////////////////////////////////
" Desc: Vim UI
" ////////////////////////////////////////////////////////////
set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd " display incomplete commands
set ruler " show the cursor position all the time
set hidden " allow to change buffer without saving
set shortmess=aoOtTI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have statue-line
set titlestring=%t\ (%{expand(\"%:p:.:h\")}/)

" set window size (if it's GUI)
if has('gui_running')
    " set window's width to 130 columns and height to 40 rows
    if exists('+lines')
        set lines=40
    endif
    if exists('+columns')
        set columns=130
    endif
    set guifont=Courier_new:h14:b:cDEFAULT
endif

set showfulltag " show tag with function protype
set guioptions+=b " present the bottom scrollbar when longest visible line exceed the window

" disable menu & toolbar
set guioptions-=m
set guioptions-=T

" ------------------------------------------------------------------
" Desc: Text edit
" ------------------------------------------------------------------
set ai " autoindent
set si " smartindent
set softtabstop=4 " delete 4 characters
set shiftwidth=4 " set shiftwidth to 4 characters
set tabstop=4 " set tabstop to 4 characters
set smarttab " change tab to space
set expandtab " set expandtab on, the tab will be change to space automaticaly
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set ve=block " in visual block mode, cursor can be positioned where there is no actual character
" set Number format to null(defualt is octal), when press CTRL-A on number
" like 007, it would not become 010
set nf = 
" indent options
" see help cinoptions-values for more details
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30

" ------------------------------------------------------------------
" Desc: Fold text
" ------------------------------------------------------------------
set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999

" ------------------------------------------------------------------
" Desc: Search
" ------------------------------------------------------------------
set showmatch " show matching paren
set incsearch " do incremental searching
set hlsearch " highlight search terms
set ignorecase " set search/replace pattern to ignore case
set smartcase " set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" set this to use id-utils for global search
set grepprg=lid\ -Rgrep\ -s
set grepformat=%f:%l:%m

"/////////////////////////////////////////////////////////////////////////////
" Auto Command
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------
" Desc: Only do this part when compiled with support for autocommands.
" ------------------------------------------------------------------

if has('autocmd')

    augroup ex
        au!

        " ------------------------------------------------------------------
        " Desc: Buffer
        " ------------------------------------------------------------------

        " when editing a file, always jump to the last known cursor position.
        " don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        au BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
        au BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
        au BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
        au BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.

        " DISABLE {
        " NOTE: will have problem with exvim, because exvim use exES_CWD as working directory for tag and other thing
        " Change current directory to the file of the buffer ( from Script#65"CD.vim"
        " au   BufEnter *   execute ":lcd " . expand("%:p:h")
        " } DISABLE end

        " ------------------------------------------------------------------
        " Desc: file types
        " ------------------------------------------------------------------

        au FileType text setlocal textwidth=78 " for all text files set 'textwidth' to 78 characters.
        au FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.

        " disable auto-comment for c/cpp, lua, javascript, c# and vim-script
        au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
        au FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://
        au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
        au FileType lua set comments=f:--

        " if edit python scripts, check if have \t. ( python said: the programme can only use \t or not, but can't use them together )
        au FileType python,coffee call s:check_if_expand_tab()
    augroup END

    function! s:check_if_expand_tab()
        let has_noexpandtab = search('^\t','wn')
        let has_expandtab = search('^    ','wn')

        "
        if has_noexpandtab && has_expandtab
            let idx = inputlist ( ['ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
                        \ '1. expand (tab=space, recommended)',
                        \ '2. noexpand (tab=\t, currently have risk)',
                        \ '3. do nothing (I will handle it by myself)'])
            let tab_space = printf('%*s',&tabstop,'')
            if idx == 1
                let has_noexpandtab = 0
                let has_expandtab = 1
                silent exec '%s/\t/' . tab_space . '/g'
            elseif idx == 2
                let has_noexpandtab = 1
                let has_expandtab = 0
                silent exec '%s/' . tab_space . '/\t/g'
            else
                return
            endif
        endif

        "
        if has_noexpandtab == 1 && has_expandtab == 0
            echomsg 'substitute space to TAB...'
            set noexpandtab
            echomsg 'done!'
        elseif has_noexpandtab == 0 && has_expandtab == 1
            echomsg 'substitute TAB to space...'
            set expandtab
            echomsg 'done!'
        else
            " it may be a new file
            " we use original vim setting
        endif
    endfunction
endif


"/////////////////////////////////////////////////////////////////////////////
" Key Mappings
"/////////////////////////////////////////////////////////////////////////////

noremap <F1> <Esc>  " 废弃F1 
set pastetoggle=<F5> " 开关粘贴模式
au InsertLeave * set nopaste " 离开插入模式时关闭粘贴模式


map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" define the copy/paste judged by clipboard
if &clipboard ==# 'unnamed'
    " fix the visual paste bug in vim
    " vnoremap <silent>p :call g:()<CR>
else
    " general copy/paste.
    " NOTE: y,p,P could be mapped by other key-mapping
    map <leader>y "*y
    map <leader>p "*p
    map <leader>P "*P
endif

" F8  Set Search pattern highlight on/off
nnoremap <F8> :let @/=""<CR>

" DISABLE: though nohlsearch is standard way in Vim, but it will not erase the
"          search pattern, which is not so good when use it with exVim's <leader>r
"          filter method
" nnoremap <F8> :nohlsearch<CR>
" nnoremap <leader>/ :nohlsearch<CR>

" map Ctrl-Tab to switch window
nnoremap <S-Up> <C-W><Up>
nnoremap <S-Down> <C-W><Down>
nnoremap <S-Left> <C-W><Left>
nnoremap <S-Right> <C-W><Right>

" easy buffer navigation
" NOTE: if we already map to EXbn,EXbp. skip setting this
if !hasmapto(':EXbn<CR>') && mapcheck('<C-l>','n') == ''
    nnoremap <C-l> :bn<CR>
endif
if !hasmapto(':EXbp<CR>') && mapcheck('<C-h>','n') == ''
    noremap <C-h> :bp<CR>
endif


" enhance '<' '>' , do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" map Up & Down to gj & gk, helpful for wrap text edit
noremap <Up> gk
noremap <Down> gj

map :Q :qall
imap <C-s> <Esc>:w!<CR>
nmap <C-s> <Esc>:w!<CR>

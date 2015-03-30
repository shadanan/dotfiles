syntax on                       " Syntax highlighting
filetype plugin indent on       " Automatically detect file types.
scriptencoding utf-8

autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

set hidden                      " Allow buffer switching without saving
set history=1000                " Store a ton of history (default is 20)
set shortmess+=filmnrxoOtT      " Abbrev. of messages (avoids 'hit enter')

set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode

highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor

" Highlight problematic whitespace
set listchars=tab:▸\ ,eol:¬,trail:•,extends:#,nbsp:. 

set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current

set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

au Filetype python setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

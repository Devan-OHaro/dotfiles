let mapleader = " "

call plug#begin()

Plug 'vimwiki/vimwiki'

Plug 'easymotion/vim-easymotion'

call plug#end()

colorscheme murphy

" Numbering schema
set number
set relativenumber

" Vimwiki configuration
let g:vimwiki_list = [{
  \ 'path': '~/Devan-Wiki/vimwiki',
  \ 'path_html': '~/Devan-Wiki/vimwiki_html/',
  \ 'syntax': 'default',
  \ 'ext': '.wiki',
  \ 'auto_diary_index': 1  
  \ }]

" Autocommand to update HTML files on save
autocmd BufWritePost *.wiki VimwikiAll2HTML

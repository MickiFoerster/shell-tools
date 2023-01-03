#!/bin/bash

set -ex 

if [[ $(dirname $0) == "." ]]; then
	SHELL_TOOLS=$PWD
else
	SHELL_TOOLS=$(dirname $0)
fi

#sudo apt-get -y install curl gcc g++ lldb lld gdb git exuberant-ctags

cd /tmp 
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz.sha256sum
sha256sum --check nvim-linux64.tar.gz.sha256sum
mkdir -p $HOME/programs
tar -C $HOME/programs -xf nvim-linux64.tar.gz

echo export PATH=\$PATH:$HOME/programs/nvim-linux64/bin
export PATH=$PATH:$HOME/programs/nvim-linux64/bin

# package manager
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p $HOME/.config/nvim
cd $HOME/.config/nvim

cat <<EOM > init.vim

:set encoding=UTF-8
:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

call plug#begin()

Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/lifepillar/pgsql.vim' " PSQL Pluging needs :SQLSetType pgsql.vim
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'https://github.com/neoclide/coc.nvim'  " Auto Completion
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'https://github.com/tc50cal/vim-terminal' " Vim Terminal
Plug 'https://github.com/preservim/tagbar' " Tagbar for code navigation
Plug 'https://github.com/terryma/vim-multiple-cursors' " CTRL + N for multiple cursors
Plug 'https://github.com/neoclide/coc.nvim'  " Auto Completion

call plug#end()

nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-l> :call CocActionAsync('jumpDefinition')<CR>

nmap <F8> :TagbarToggle<CR>

:set completeopt-=preview " For No Previews

:colorscheme jellybeans

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" Set CR as key for taking selection in autocomplete
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
EOM

cd -

$HOME/programs/nvim-linux64/bin/nvim +PlugInstall

# CoC installation
# for CoC plugin we need node.js
${SHELL_TOOLS}/install-node.js.sh

dir=$HOME/.local/share/nvim/plugged/coc.nvim 
if [[ -d $dir ]] ; then
	cd $dir
	npm install -g yarn
	yarn install 
	yarn build
	nvim +CocInstall coc-python coc-tsserver coc-json coc-html coc-css coc-rust-analyzer coc-sh coc-sql coc-texlab coc-toml coc-yaml coc-go coc-explorer coc-docker
	pip3 install pynvim jedi # for coc-python
	cd -
fi


#git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

set +ex 

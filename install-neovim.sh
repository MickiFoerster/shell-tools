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

mkdir -p $HOME/.config
rm -rf $HOME/.config/nvim
git clone https://github.com/MickiFoerster/config-nvim.git $HOME/.config/nvim

rm -rf ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

nvim +PackerSync

# For TreeSitter plugin, see  https://github.com/nvim-treesitter/nvim-treesitter#adding-parsers
cargo install tree-sitter-cli

set +ex 

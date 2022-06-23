#!/bin/sh

set -e
oldwd=`pwd`
cd /tmp
nvim_version=$(curl -L https://github.com/neovim/neovim/releases/latest | \
    grep -E "href=\"[^\"]*\/[^\"]*\/nvim-linux64.tar.gz\"" | \
    sed "s#.*/download/\(v[0-9\.]*\)/nvim-linux64.tar.gz.*#\1#")
echo Download nvim in version ${nvim_version}
curl -LO "https://github.com/neovim/neovim/releases/download/${nvim_version}/nvim-linux64.tar.gz"
mkdir -p $HOME/programs
cd $HOME/programs
tar xf /tmp/nvim-linux64.tar.gz
cd nvim-linux64/bin
echo "Installed nvim ${nvim_version} into $PWD."
a=$PWD/nvim
b=$(which nvim)
if [ "$a" != "$b" ] ; then
    echo "warning: PATH is NOT pointing to the installed nvim binary"
    echo "Remember to add this path to PATH"
fi
cd ${oldwd}


# Install vim-plub (https://github.com/junegunn/vim-plug)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall!
#nvim +PlugUpdate!

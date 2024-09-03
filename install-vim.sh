#!/bin/bash

BUILDDIR=~/workspace/external-projects
OLDDIR=$PWD

set -ex

function vim-basic-install() {
    sudo apt install libncurses-dev \
        libpython3-dev \
        python3-dev
    mkdir -p $BUILDDIR &&
        cd $BUILDDIR
    if [ -d vim ]; then
        rm -rf vim
    fi
    git clone https://github.com/vim/vim.git
    cd vim
    ./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes \
        --enable-python3interp=yes --with-python3-command=/usr/bin/python3 \
        --disable-pythoninterp --enable-perlinterp=yes --enable-luainterp=yes --enable-gui=gtk2 --enable-cscope --prefix=/usr/local
    make -j4
    echo "Build successful, now install into /usr/local"
    sudo make install
    sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
    sudo update-alternatives --set editor /usr/local/bin/vim
    sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
    sudo update-alternatives --set vi /usr/local/bin/vim
    echo "vim installation successful. Configuration of .vimrc is missing"
    rm -rf ~/.vim
    ln -sf $BUILDDIR/vim/runtime ~/.vim
    echo ".vim is now link to runtime directory"
}

function vundle() {
    ${OLDDIR}/install-node.js.sh

    dir=Vundle.vim
    if [ ! -d ~/.vim/bundle/$dir ]; then
        git clone https://github.com/gmarik/$dir.git ~/.vim/bundle/$dir
    else
        cd ~/.vim/bundle/$dir
        git pull
        cd ..
    fi
    if [ ! -d ~/.vim/pack/plugins/start/vim-go ]; then
        git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
    else
        cd ~/.vim/pack/plugins/start/vim-go && git pull && cd ..
    fi
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    if [[ -f ~/.vimrc ]]; then
        mv ~/.vimrc ~/.vimrc.old
    fi
    cp -v ${OLDDIR}/vim.rc.template ~/.vimrc
    vim +PlugInstall
    #vim +CocInstall coc-tsserver coc-json coc-html coc-css coc-rust-analyzer coc-sh coc-sql coc-sql coc-texlab coc-toml coc-yaml coc-nginx coc-go coc-explorer coc-docker coc-ansible
    echo "DONE"
}

vim-basic-install
vundle

#		&& dir=YouCompleteMe;if [ ! -d ~/.vim/bundle/$dir ];then \
#		   git clone https://github.com/Valloric/$dir.git ~/.vim/bundle/$dir ;\
#			 else cd ~/.vim/bundle/$dir;git pull;cd ..;fi && cd $dir && \
#			 git submodule update --init --recursive && ./install.py --all && cd .. \
#	    && dir=$$HOME/.vim/pack/plugins/start/vim-terraform && \
#	   	   if [ ! -d $${dir} ]; then \
#		   	 git clone https://github.com/hashivim/vim-terraform.git $${dir}; \
#		   else \
#		   	 cd  $${dir} && git pull && cd - ; \
#		   fi \

#--with-python3-config-dir=/usr/lib/python3.7/config \
# Auto-update ctags files:
# git clone git://github.com/craigemery/vim-autotag.git ~/.vim/bundle/vim-autotag

#		&& rm -f ~/.vim && ln -s $BUILDDIR/vim/runtime ~/.vim \
#		&& dir=Vundle.vim \
#		&& if [ ! -d ~/.vim/bundle/$dir ];then \
#		   git clone https://github.com/gmarik/$dir.git ~/.vim/bundle/$dir ;\
#			 else cd ~/.vim/bundle/$dir;git pull;cd ..;fi \
#		&& dir=YouCompleteMe;if [ ! -d ~/.vim/bundle/$dir ];then \
#		   git clone https://github.com/Valloric/$dir.git ~/.vim/bundle/$dir ;\
#			 else cd ~/.vim/bundle/$dir;git pull;cd ..;fi && cd $dir && \
#			 git submodule update --init --recursive && ./install.py --all && cd .. \
#		&& if [ ! -d ~/.vim/pack/plugins/start/vim-go ]; then \
#		     git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go; \
#		   else \
#	         cd ~/.vim/pack/plugins/start/vim-go && git pull && cd .. ; \
#		   fi \
#	    && dir=$$HOME/.vim/pack/plugins/start/vim-terraform && \
#	   	   if [ ! -d $${dir} ]; then \
#		   	 git clone https://github.com/hashivim/vim-terraform.git $${dir}; \
#		   else \
#		   	 cd  $${dir} && git pull && cd - ; \
#		   fi \

#!/bin/bash 

if dpkg -l fzf | grep "^ii"; then 
	sudo apt remove fzf
fi

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

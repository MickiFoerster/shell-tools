#!/bin/bash 

if dpkg -l fzf | grep "^ii"; then 
	sudo apt remove fzf
fi

if [[ ! -d ~/.fzf ]]; then 
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
fi

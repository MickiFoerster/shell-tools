#!/bin/bash


set -ex

cd /tmp/
rm -f Hack.zip
curl -LO "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip"
unzip Hack.zip
mkdir -p ~/.local/share/fonts/
mv *.ttf ~/.local/share/fonts/

fc-cache -f -v 
fc-list | grep Hack

set +ex

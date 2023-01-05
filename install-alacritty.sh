#!/bin/bash

set -ex

cd /tmp

rustup override set stable
rustup update stable

sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

rm -rf /tmp/alacritty
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo install alacritty
cd /tmp
rm -rf /tmp/alacritty

set +ex

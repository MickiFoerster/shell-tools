#!/bin/bash

set -ex

cd /tmp
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo install alacritty
cd /tmp
rm -rf /tmp/alacritty

set +ex

#!/bin/bash

set -ex

cd /tmp
git clone https://github.com/helix-editor/helix
cd helix
cargo install --path helix-term
mkdir -p $HOME/.config/helix
rsync -av ./runtime/ $HOME/.config/helix/runtime/

set +ex

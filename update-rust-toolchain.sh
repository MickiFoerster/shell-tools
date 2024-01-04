#!/bin/bash

rustup update
rustup component add rust-analyzer

cargo install tree-sitter-cli

cd ~/.config/nvim && git pull
nvim +PackerSync
#nvim +PackerClean
nvim +MasonUpdate
nvim +TSUpdate

#!/bin/bash

rustup update
cargo install tree-sitter-cli
cd ~/.config/nvim && git pull
nvim +PackerSync
nvim +PackerClean
nvim +TSUpdate

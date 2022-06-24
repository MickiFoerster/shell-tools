#!/bin/bash

set -ex

# rustup
curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh

# cargo packages
for pkg in \
    cargo-edit    \
    cargo-expand    \
    cargo-watch    \
    grcov    \
    rustlings    \
    rusty-tags \
    sea-orm-cli    \
    sqlx-cli    \
    tokio-console    \
; do
    cargo install ${pkg}
done





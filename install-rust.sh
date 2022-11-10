#!/bin/bash

set -ex

if ! which rustup; then
    curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh
fi

# In order to use `cargo +nightly expand`
rustup toolchain install nightly --allow-downgrade
rustup component add rust-analyzer

export PATH=$HOME/.cargo/bin:$PATH

# cargo packages
for pkg in \
    cargo-cranky   \
    cargo-edit     \
    cargo-expand   \
    cargo-nextest   \
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
# crates-mirror

if ! which lldb; then
    echo "Install LLDB ..."
    sudo apt install lldb
fi

set +ex

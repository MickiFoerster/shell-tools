#!/bin/bash

set -ex

if ! which rustup; then
    curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh
fi

# In order to use `cargo +nightly expand`
rustup toolchain install nightly --allow-downgrade

for i in \
    rustfmt \
    clippy  \
    rust-analyzer \
    ; do
    rustup component add $i
done

export PATH=$HOME/.cargo/bin:$PATH

# cargo packages
for pkg in \
    cargo-audit \
    cargo-cranky   \
    cargo-expand \
    cargo-nextest   \
    cargo-watch    \
    grcov    \
    rustlings    \
    rusty-tags \
    sea-orm-cli    \
    sqlx-cli    \
    tokio-console    \
    cargo-tarpaulin \
    cargo-update  \
    ; do
    cargo install ${pkg}
done
# crates-mirror
# cargo-edit   cargo add is now inside cargo command itself

if ! which lldb; then
    echo "Install LLDB ..."
    sudo apt install lldb
fi

set +ex

#!/bin/bash 

# cargo test
# cargo tarpaulin --ignore-tests

rustup component add clippy
cargo clippy -- -D warnings

rustup component add rustfmt
cargo fmt -- --check

#cargo install cargo-audit
cargo audit

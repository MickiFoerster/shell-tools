#!/bin/bash

url=$(curl -s -L "https://github.com/rust-lang/rust-analyzer/releases/latest"|\
    egrep "href=\"/.*rust-analyzer-x86_64-unknown-linux-gnu.gz\"" | \
    sed "s#.*href=\"\(/.*rust-analyzer-x86_64-unknown-linux-gnu.gz\)\".*#\1#" |\
    xargs -iarg echo https://github.comarg)
url=https://github.com/rust-lang/rust-analyzer/releases/download/2022-12-12/rust-analyzer-x86_64-unknown-linux-gnu.gz
set -e
cd /tmp/
rm -f rust-analyzer-x86_64-unknown-linux-gnu*
curl -LO "${url}" 
gunzip rust-analyzer-x86_64-unknown-linux-gnu.gz
if [ -f $HOME/.cargo/bin/rust-analyzer ]; then
    mv $HOME/.cargo/bin/rust-analyzer $HOME/.cargo/bin/rust-analyzer.old
fi
chmod 700 rust-analyzer-x86_64-unknown-linux-gnu
mv -v rust-analyzer-x86_64-unknown-linux-gnu $HOME/.cargo/bin/rust-analyzer
echo "rust-analyzer successfully updated"
set +e

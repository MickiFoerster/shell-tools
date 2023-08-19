#!/bin/bash

set -ex 

cd $HOME || exit 1

python -m venv python-venv-yt-dlp

source ./python-venv-yt-dlp/bin/activate

python -m pip install yt-dlp

echo "For automatic loading the venv you can use for example:"
cat <<EOM

function yt-dlp() {
    if ! echo \$PS1 | grep -q python-venv-yt-dlp; then
        source \$HOME/python-venv-yt-dlp/bin/activate
    fi
    unset -f yt-dlp
    yt-dlp \$@
}

EOM

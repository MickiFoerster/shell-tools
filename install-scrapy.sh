#!/bin/bash

set -ex 

cd $HOME || exit 1

python -m venv python-venv-scrapy

source ./python-venv-scrapy/bin/activate

# autopep8: autopep8 automatically formats Python code to conform to the `PEP 8`_ style.
python -m pip install scrapy pylint autopep8

echo "For automatic loading the venv you can use for example:"
cat <<EOM

function scrapy() {
    if ! echo \$PS1 | grep -q python-venv-scrapy; then
        source \$HOME/python-venv-scrapy/bin/activate
    fi
    unset -f scrapy
    scrapy \$@
}

EOM

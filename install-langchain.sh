#!/bin/bash

set -ex

cd $HOME

if [[ ! -d langchain ]]; then
    python3 -m venv langchain
fi

. langchain/bin/activate

pip install --upgrade pip
pip install langchain
pip install langchain-openai
pip install langchain-community
pip install langchainhub

set +ex

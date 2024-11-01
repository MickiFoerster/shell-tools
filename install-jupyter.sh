#!/bin/bash

set -ex

cd $HOME
python -m venv jupyter

source jupyter/bin/activate

pip install --upgrade pip
pip install jupyterlab
pip install notebook
pip install voila

jupyter notebook

set +ex

#!/bin/bash

set -ex 

python -m venv python-venv-keras
source python-venv-keras/bin/activate
pip install ipython
pip install theano
pip install tensorflow
pip install keras

set +ex

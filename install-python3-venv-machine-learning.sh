#!/bin/bash

set -ex

cd $HOME

if ! dpkg -l python3-venv | /usr/bin/grep "^ii"; then
    sudo apt install python3-venv
fi

d=python-venv-machine-learning
if [[ ! -d machine-learning ]]; then
    python3 -m venv $d
fi

. ./$d/bin/activate

pip install --upgrade pip
pip install numpy
pip install matplotlib
pip install pandas
pip install -U scikit-learn
pip install tensorflow[and-cuda]
#pip install tensorflow[and-cuda]==2.16.1
#pip install keras
# For CUDA 11.8:
#pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
#pip3 install torch torchvision torchaudio

pip install jupyterlab
pip install notebook

set +ex

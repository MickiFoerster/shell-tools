#!/bin/bash

set -ex

cd $HOME

if ! dpkg -l python3-venv | /usr/bin/grep "^ii"; then
    sudo apt install python3-venv
fi

if [[ ! -d machine-learning ]]; then
    python3 -m venv machine-learning
fi

. ./machine-learning/bin/activate

pip install --upgrade pip
pip install numpy
pip install matplotlib
pip install pandas
pip install -U scikit-learn
#pip install tensorflow
pip install tensorflow[and-cuda]
pip install keras
# For CUDA 11.8:
#pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip3 install torch torchvision torchaudio

set +ex

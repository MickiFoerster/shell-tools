#!/bin/bash

set -ex

cd $HOME
sudo apt install python3-venv
python3 -m venv machine-learning
. ./machine-learning/bin/activate

pip install numpy
pip install matplotlib
pip install pandas
#pip install sklearn
pip install -U scikit-learn

set +ex

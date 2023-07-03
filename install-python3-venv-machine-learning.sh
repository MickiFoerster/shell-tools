#!/bin/bash

set -ex

cd $HOME
sudo apt install python3.10-venv
python3 -m venv machine-learning
. ./machine-learning/bin/activate

set +ex

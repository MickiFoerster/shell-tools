#!/bin/bash

set -e
./mach bootstrap
./mach bootstrap-gstreamer
if which clang | grep -q clang; then
    echo "With clang all builds failed at the moment, so disable it"
    export PATH=$(echo $PATH | tr ':' '\n' | grep -v clang | tr '\n' ':')
fi
./mach build --dev



# curl https://bootstrap.pypa.io/get-pip.py -sSf -o get-pip.py
# apt install curl
# apt search curl
# apt-cache search curl
# curl
# dpkg -l
# apt install curl
# curl https://sh.rustup.rs -sSf | sh
# python2 get-pip.py
# python2 -m pip install virtualenv
# sudo apt install python-dev
# apt install python-dev
# apt install gstreamer1.0-nice gstreamer1.0-plugins-bad
# apt install git
# pwd
# cd root/
# ls
# cd
# cd root
# cd /root
# pwd
# git clone https://github.com/servo/servo
# cd servo/
# ./mach build --dev && echo SUCCESS
# curl https://bootstrap.pypa.io/get-pip.py -sSf -o get-pip.py
# python2 get-pip.py
# python2 -m pip install virtualenv
# apt install python-dev
# ./mach build --dev && echo SUCCESS
# curl https://sh.rustup.rs -sSf | sh
# source $HOME/.cargo/env
# ./mach build --dev && echo SUCCESS
# gcc
# apt install gcc g++
# ./mach build --dev && echo SUCCESS
# apt install pkg-config
# ./mach build --dev && echo SUCCESS
# ./mach bootstrap-gstreamer
# ./mach build --dev && echo SUCCESS
# pkg-config
# bash
# which pkg-config
# ./mach build --dev && echo SUCCESS
# pkg-config --libs --cflags x11 >= 1.4.99.1

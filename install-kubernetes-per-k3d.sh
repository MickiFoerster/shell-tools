#!/bin/bash

export USE_SUDO=false
export K3D_INSTALL_DIR=$HOME/bin

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash -x

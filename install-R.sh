#!/bin/bash

set -ex

cd /tmp

wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/r-project.gpg

echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee -a /etc/apt/sources.list.d/r-project.list

sudo apt update

sudo apt install --no-install-recommends r-base

echo "install.packages('txtplot')" | sudo -i R --no-save

curl -LO https://download1.rstudio.org/electron/jammy/amd64/rstudio-2023.09.0-463-amd64.deb
sudo dpkg -i rstudio-2023.09.0-463-amd64.deb

set +ex

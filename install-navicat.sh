#!/bin/bash

set -ex
cd /tmp/
curl -LO 'https://dn.navicat.com/download/navicat16-pgsql-en.AppImage'
curl -LO 'https://dn.navicat.com/download/modeler3-en.AppImage'
sudo apt install libfuse2
chmod 755 modeler3-en.AppImage
chmod 755 navicat16-pgsql-en.AppImage

echo "Evaluation software from Navicat is ready:"
ls -l *.AppImage

set +ex

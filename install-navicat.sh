#!/bin/bash

set -ex
cd /tmp/
curl -LO 'https://www.navicat.com/download/direct-download?product=navicat16-pgsql-en.AppImage&location=1'
curl -LO 'https://www.navicat.com/download/direct-download?product=modeler3-en.AppImage&location=1'

sudo apt install libfuse2
chmod 755 modeler3-en.AppImage
chmod 755 navicat16-pgsql-en.AppImage

echo "Evaluation software from Navicat is ready:"
ls -l *.AppImage

set +ex

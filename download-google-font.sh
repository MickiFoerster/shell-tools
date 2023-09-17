#!/bin/bash

if [[ "$1" == "" ]]; then 
	url="https://fonts.googleapis.com/css?family=Lato:100,300,400,700,900"
else
	url="$1"
fi
echo "Downloading google font from URL ${url}"

set -e
cd /tmp

curl -L "${url}" > fontlist
grep http fontlist | sed "s#.*url(\(.*ttf\)).*#\1#" > lst
cat lst | xargs -ixxx echo curl -LO \"xxx\" > todo.sh
mkdir -p ttf 
cd ttf 
bash -x ../todo.sh

echo "Fonts were downloaded into folder $PWD"

set +e

#!/bin/bash 


set -ex 

cd $HOME

for i in \
	google-cloud-vision \
	google-cloud-natural-language \
; do 
	d=python-venv-$i
	if [ ! -d $d ]; then 
		python3 -m venv $d
	fi
	source $d/bin/activate

	pip install --upgrade pip 
	pip install --upgrade $i 
done


set +ex

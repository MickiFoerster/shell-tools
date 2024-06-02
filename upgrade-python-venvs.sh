#!/bin/bash  -x

for i in $HOME/python-venv-* ; 
do
    t=$(echo $i | sed "s#$HOME/python-venv-\(.*\)#\1#")
    source $i/bin/activate
    pip install --upgrade $t
done

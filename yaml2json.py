#!/bin/bash

if [[ "$1" == "" || ! -f "$1" ]]; then
	echo "error: Give YAML file as parameter"
	exit 1
fi

python3 -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin, Loader=yaml.FullLoader), sys.stdout, indent=4)' <$1

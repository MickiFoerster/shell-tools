#!/bin/sh	
dir=$$HOME/workspace/external-projects && \
cd $$dir && \
dir=emsdk && \
if [ -d $$dir ]; then 
	cd $$dir; 
	git pull;
else
	git clone https://github.com/emscripten-core/emsdk.git;
	cd $$dir ; 
fi && \
dir=`pwd` && \
$$dir/emsdk install latest && \
$$dir/emsdk activate lastest && \
source $$dir/emsdk_env.sh

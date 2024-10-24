#!/bin/bash

set -ex

cd /tmp/
curl -fsSL https://ollama.com/install.sh >install-ollama.sh

chmod 700 install-ollama.sh
bash -x ./install-ollama.sh

set +ex

#!/bin/bash

# https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md#Instructions-for-Google-Employees

# install depot_tools
#git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
#export PATH="$PATH:/path/to/depot_tools"
mkdir ~/chromium && cd ~/chromium
fetch --nohooks chromium
./build/install-build-deps.sh
gclient runhooks
gn gen out/Default
autoninja -C out/Default chrome
out/Default/chrome

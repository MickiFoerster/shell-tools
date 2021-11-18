#!/bin/bash

ps -ef | \
    grep VBoxHeadless | \
    grep startvm | \
    sed "s#.*startvm\ \([a-f0-9-]*\)\ .*#\1#" | \
    xargs -ixxx echo VBoxManage controlvm xxx acpipowerbutton

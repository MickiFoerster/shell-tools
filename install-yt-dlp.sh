#!/bin/bash
#
set -ex
cd /tmp
curl -LO "https://github.com/yt-dlp/yt-dlp/releases/download/2023.03.04/yt-dlp_linux"
chmod 755 yt-dlp_linux
mv yt-dlp_linux ~/bin/yt-dlp
set +ex

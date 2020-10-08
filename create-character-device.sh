#!/bin/sh

mknod -m 660 /dev/ttyS23 c 247 2
chgrp root:dialout /dev/ttyS23

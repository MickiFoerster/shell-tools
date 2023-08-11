#!/usr/bin/python3

import sys

# no argument given then return
if len(sys.argv) == 1:
    sys.exit(0)

lst = sys.argv[1].split(":")

# vim "+call cursor(35,22)"
# or vim "+normal <LINE>G<COLUMN>|"
if len(lst) >= 2 and len(lst[1]) > 0:
    print("{} +{}".format(lst[0], lst[1]), end='')
else:
    for arg in sys.argv[1:]:
        print(f"{arg} ", end='')

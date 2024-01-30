#!/usr/bin/python3

import os
import sys

# no argument given then return
if len(sys.argv) == 1:
    sys.exit(0)

lst = sys.argv[1].split(":")

# vim "+call cursor(35,22)"
# or vim "+normal <LINE>G<COLUMN>|"
if len(lst) >= 2 and len(lst[1]) > 0:
    file_path = lst[0]
    pos = lst[1]

    if not os.path.exists(file_path):
        lst = file_path.split("/")
        for i, p in enumerate(lst):
            pwd = os.getcwd()
            pwd_lst = pwd.split("/")
            for j in range(len(pwd_lst)-1, -1, -1):
                if p == pwd_lst[j]:
                    rp = "/".join(lst[i+1:])
                    if os.path.exists(rp):
                        file_path = rp

    print("{} +{}".format(file_path, pos), end='')
else:
    for arg in sys.argv[1:]:
        print(f"{arg} ", end='')

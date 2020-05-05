#!/usr/bin/env python3

import sys
import subprocess
import re
import os

file=''
if len(sys.argv)>1:
    if os.path.isfile(sys.argv[1]):
        commits = subprocess.check_output(['git', 'log', '--pretty=oneline', \
                                          '-10', '--', sys.argv[1]])
        file = sys.argv[1]
    else:
        print('error: Argument {} is not a file.'.format(sys.argv[0]))
        sys.exit(1)
else:
    commits = subprocess.check_output(['git', 'log', '--pretty=oneline', '-10'])
diffs = []
successor = ""
predecessor = ""
for line in commits.splitlines():
    hash = re.match('^[a-fA-F0-9]+', line.decode('utf-8'))
    if hash is not None:
        if len(successor) == 0:
            successor = hash.group(0)
        else:
            predecessor = hash.group(0)
            diff = []
            diff.append(predecessor)
            diff.append(successor)
            diffs.append(diff)
            successor = predecessor

for diff in diffs:
    if file == '':
        subprocess.run(['git', 'difftool', '--tool=vimdiff', diff[0], diff[1]])
    else:
        subprocess.run(['git', 'difftool', '--tool=vimdiff', diff[0], diff[1],\
                       file])
    print("Show next difference?")
    continue_or_not = input()
    if continue_or_not != 'y':
        break;


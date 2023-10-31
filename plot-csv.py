#!/usr/bin/env python3

import sys
import os

if len(sys.argv) != 2:
    print('missing argument: Give name of CSV file as argument.')
    sys.exit(1)

input_file = sys.argv[1]
if not os.path.isfile(input_file):
    print(f'{input_file} is not a file')
    sys.exit(1)

print('Plotting file {input_file}')

import pandas as pd
try:
    dataset = pd.read_csv(input_file)
except:
    print('error: could not read CSV file')
    sys.exit(1)

X = dataset.iloc[:, :-1].values
print("X values:", X)

Y = dataset.iloc[:, -1].values
print("Y values:", Y)

import matplotlib.pyplot as plt
plt.scatter(X, Y, color = 'red')
plt.title(f'CSV file {input_file}')
plt.xlabel('x values')
plt.ylabel('y values')
plt.show()

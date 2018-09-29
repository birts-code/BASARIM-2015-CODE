#!/usr/bin/env python2

import sys

num_procs = int(sys.argv[1])

f = open('comm.txt', 'r')
lines = f.readlines()
f.close()

spks = [[0 for i in range(num_procs)] for j in range(num_procs)]
for line in lines:
    if 'number of spks' in line:
        toks = line.split()
        pid = int(toks[0][1:-1])
        num = int(toks[-1])
        spks[pid] = [num for i in range(num_procs)]
        spks[pid][pid] = 0

comm = [[0 for i in range(num_procs)] for j in range(num_procs)]
for i in range(num_procs):
    for j in range(num_procs):
        comm[i][j] = spks[i][j] + spks[j][i]

f = open('graph.txt', 'w')
f.write('%d %d 001\n' % (num_procs, num_procs * (num_procs - 1) / 2))
for i in range(num_procs):
    for j in range(num_procs):
        if i == j: continue
        f.write('%d %d ' % (j + 1, comm[i][j]))
    f.write('\n')
f.close()

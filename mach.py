#!/usr/bin/env python2

import sys

num_procs = int(sys.argv[1])
num_parts = int(sys.argv[2])

f = open('machinefile', 'r')
machs = f.readlines()
f.close()

f = open('graph.txt.part.%d' % num_parts, 'r')
parts = map(lambda line: int(line[:-1]), f.readlines())
f.close()

f = open('machinefile-%d-%d' % (num_procs, num_parts), 'w')
for part in parts:
    f.write(machs[part % len(machs)])
f.close()

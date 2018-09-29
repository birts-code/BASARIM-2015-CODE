#!/usr/bin/env python2

import sys

fname = sys.argv[1]

f = open(fname, 'r')
lines = f.readlines()
f.close()

time_tots = []
time_ints = []
time_spks = []

for line in lines:
    if 'time of ints' in line:
        time_ints.append(float(line.split()[-1]))
    if 'time of spks' in line:
        time_spks.append(float(line.split()[-1]))
    if 'total time' in line:
        time_tots.append(float(line.split()[-1]))

def avg(nums):
    return sum(nums) / float(len(nums))

org_comm = avg(time_ints[::2]) + avg(time_spks[::2])
opt_comm = avg(time_ints[1::2]) + avg(time_spks[1::2])
org_total = avg(time_tots[::2])
opt_total = avg(time_tots[1::2])

print '(original)  comm time  :', org_comm
print '(optimized) comm time  :', opt_comm
print '(original)  total time :', org_total
print '(optimized) total time :', opt_total
print 'comm impr (%)          :', 100 * ((org_comm - opt_comm) / org_comm)
print 'total impr (%)         :', 100 * ((org_total - opt_total) / org_total)

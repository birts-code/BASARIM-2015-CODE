#!/usr/bin/env python2

import sys

num_procs = int(sys.argv[1])

def print_stats(fname):
    f = open(fname, 'r')
    lines = f.readlines()
    f.close()

    avg_num_of_ints = 0.0
    avg_num_of_spks = 0.0
    avg_time_of_ints = 0.0
    avg_time_of_spks = 0.0
    avg_total_time = 0.0
    for line in lines:
        toks = line.split()
        if 'number of ints' in line:
            avg_num_of_ints += float(toks[-1])
        if 'number of spks' in line:
            avg_num_of_spks += float(toks[-1])
        if 'time of ints' in line:
            avg_time_of_ints += float(toks[-1])
        if 'time of spks' in line:
            avg_time_of_spks += float(toks[-1])
        if 'total time' in line:
            avg_total_time += float(toks[-1])

    avg_num_of_ints /= num_procs
    avg_num_of_spks /= num_procs
    avg_time_of_ints /= num_procs
    avg_time_of_spks /= num_procs
    avg_total_time /= num_procs

    print
    print 'average number of ints :', avg_num_of_ints
    print 'average number of spks :', avg_num_of_spks
    print 'average time of ints   :', avg_time_of_ints
    print 'average time of spks   :', avg_time_of_spks
    print 'average total time     :', avg_total_time
    print

print

print 'statistics for the original'
print '---------------------------'
print_stats('comm.txt')

print
print 'statistics for the optimized'
print '----------------------------'
print_stats('comm-opt.txt')

#!/bin/bash

#if [ "$#" -ne 2 ]; then
#    echo
#    echo "  usage: $0 <NUMBER_OF_PROCESSES> <NUMBER_OF_PARTITIONS>"
#    echo
#    exit 1
#fi

#num_procs=$1
#num_parts=$2

num_procs=8
num_parts=2

BASE=$(pwd)

dorun() {
    cd SenseLab/netmod/parbulbNet
    mpirun -np $1 -machinefile $2 $BASE/neuron/nrn/build/x86_64/bin/nrniv -mpi par_batch1.hoc >& temp
    rm -r -f result.$1
    mkdir result.$1
    cp ddi* result.$1
    sort -k 1n,1n -k 2n,2n out.dat > out.$1
    mv temp stdout.$1
    cd - >& /dev/null
}

dorun $num_procs $BASE/machinefile

cat SenseLab/netmod/parbulbNet/comm-*.txt > comm.txt

rm SenseLab/netmod/parbulbNet/comm-*.txt

./comm.py $num_procs

$BASE/metis/metis-5.1.0/install/bin/gpmetis graph.txt $num_parts >& /dev/null

./mach.py $num_procs $num_parts

dorun $num_procs $BASE/machinefile-${num_procs}-${num_parts}

cat SenseLab/netmod/parbulbNet/comm-*.txt > comm-opt.txt

rm SenseLab/netmod/parbulbNet/comm-*.txt

./stat.py $num_procs

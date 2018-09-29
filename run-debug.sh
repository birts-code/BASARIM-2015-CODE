#!/bin/bash

IV=$HOME/Desktop/brain/neuron/iv
NRN=$HOME/Desktop/brain/neuron/nrn

CPU=x86_64
BLD=build
PATH="$IV/$CPU/bin:$NRN/$BLD/$CPU/bin:$PATH"

mpirun -np 4 nrniv -mpi inputs/test0.hoc
# mpirun -np 4 xterm -e gdb --args nrniv -mpi inputs/test0.hoc

# cd SenseLab/netmod/parbulbNet; mpirun -np 4 nrniv -mpi par_batch1.hoc; cd -
# cd SenseLab/netmod/parbulbNet; mpirun -np 4 xterm -e gdb --args nrniv -mpi par_batch1.hoc; cd -

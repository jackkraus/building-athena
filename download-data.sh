#!/bin/bash

#retrieve inputs

rucio download data22_13p6TeV:AOD.31407809._000896.pool.root.1
ln -fs data22_13p6TeV/AOD.31407809._000896.pool.root.1 ./AOD.31407809._000896.pool.root.1
rucio download data22_13p6TeV:AOD.31407809._000898.pool.root.1
ln -fs data22_13p6TeV/AOD.31407809._000898.pool.root.1 ./AOD.31407809._000898.pool.root.1
rucio download data22_13p6TeV:AOD.31407809._000894.pool.root.1
ln -fs data22_13p6TeV/AOD.31407809._000894.pool.root.1 ./AOD.31407809._000894.pool.root.1
rucio download data22_13p6TeV:AOD.31407809._000895.pool.root.1
ln -fs data22_13p6TeV/AOD.31407809._000895.pool.root.1 ./AOD.31407809._000895.pool.root.1

#transform commands


# !!!! IMPORTANT !!!!
# Go to the respective athena /build directory that you've created/want to test and run 'asetup --restore'
# !!!! IMPORTANT !!!!


export ATHENA_PROC_NUMBER=8
export ATHENA_CORE_NUMBER=8
Derivation_tf.py --inputAODFile="AOD.31407809._000894.pool.root.1,AOD.31407809._000895.pool.root.1,AOD.31407809._000896.pool.root.1,AOD.31407809._000898.pool.root.1" --athenaMPMergeTargetSize "DAOD_*:0" --multiprocess True --sharedWriter True --formats PHYS PHYSLITE --outputDAODFile 34859516._000364.pool.root.1 --multithreadedFileValidation True --AMITag p5858 --CA "all:True"


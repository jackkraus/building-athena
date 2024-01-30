#!/bin/bash

#retrieve inputs

rucio download mc23_13p6TeV:AOD.33799166._000303.pool.root.1
ln -fs mc23_13p6TeV/AOD.33799166._000303.pool.root.1 ./AOD.33799166._000303.pool.root.1
rucio download mc23_13p6TeV:AOD.33799166._000304.pool.root.1
ln -fs mc23_13p6TeV/AOD.33799166._000304.pool.root.1 ./AOD.33799166._000304.pool.root.1
rucio download mc23_13p6TeV:AOD.33799166._000305.pool.root.1
ln -fs mc23_13p6TeV/AOD.33799166._000305.pool.root.1 ./AOD.33799166._000305.pool.root.1
rucio download mc23_13p6TeV:AOD.33799166._000306.pool.root.1
ln -fs mc23_13p6TeV/AOD.33799166._000306.pool.root.1 ./AOD.33799166._000306.pool.root.1
rucio download mc23_13p6TeV:AOD.33799166._000307.pool.root.1
ln -fs mc23_13p6TeV/AOD.33799166._000307.pool.root.1 ./AOD.33799166._000307.pool.root.1
rucio download mc23_13p6TeV:AOD.33799166._000308.pool.root.1
ln -fs mc23_13p6TeV/AOD.33799166._000308.pool.root.1 ./AOD.33799166._000308.pool.root.1

#transform commands

# !!!! IMPORTANT !!!!
# Go to the respective athena /build directory that you've created/want to test and run 'asetup --restore'
# !!!! IMPORTANT !!!!


export ATHENA_PROC_NUMBER=8
export ATHENA_CORE_NUMBER=8
Derivation_tf.py --inputAODFile="AOD.33799166._000303.pool.root.1,AOD.33799166._000304.pool.root.1,AOD.33799166._000305.pool.root.1,AOD.33799166._000306.pool.root.1,AOD.33799166._000307.pool.root.1,AOD.33799166._000308.pool.root.1" --athenaMPMergeTargetSize "DAOD_*:0" --multiprocess True --postExec "default:if ConfigFlags.Concurrency.NumProcs>0: cfg.getService(\"AthMpEvtLoopMgr\").ExecAtPreFork=[\"AthCondSeq\"];" --sharedWriter True --formats PHYS PHYSLITE --outputDAODFile 35010062._000389.pool.root.1 --multithreadedFileValidation True --AMITag p5855 --CA "all:True"


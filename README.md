The following script can be found in this repository at `setup-athena.sh`

This creates directories to setup the various configurations of Athena (default at 128kB basket, no-limit size basket, 256kB basket size, and 512kB basket size). I know it's a bit cumbersome and ugly but it proved easier than without it. 

```
#!/bin/bash

# Create directories
mkdir athena-default;
mkdir athena-no-limit;
mkdir athena-256k-basket;
mkdir athena-512k-basket;

# Clone and setup for athena-default
cd athena-default;
git clone https://gitlab.cern.ch/akraus/athena.git;
cd athena;
git remote add upstream https://:@gitlab.cern.ch:8443/atlas/athena.git ;
git fetch --all;
git checkout release/24.0.16 ; 
cd ..;
git clone https://github.com/arthurkraus3/building-athena.git;
rm athena/Database/AthenaPOOL/AthenaPoolCnvSvc/python/PoolWriteConfig.py;
mv building-athena/PoolWriteConfig.py athena/Database/AthenaPOOL/AthenaPoolCnvSvc/python/;
mv building-athena/package_filters.txt .;
mkdir build && cd build ; 
lsetup "asetup Athena,24.0.16" ; 
cmake -DATLAS_PACKAGE_FILTER_FILE=../package_filters.txt ../athena/Projects/WorkDir/ >& cmakelog;
make -j >& makelog;
cd ..

# Clone and setup for athena-no-limit
cd athena-no-limit;
git clone https://gitlab.cern.ch/akraus/athena.git;
cd athena;
git remote add upstream https://:@gitlab.cern.ch:8443/atlas/athena.git ;
git fetch --all;
git checkout release/24.0.16 ; 
cd ..;
git clone https://github.com/arthurkraus3/building-athena.git;
rm athena/Database/AthenaPOOL/AthenaPoolCnvSvc/python/PoolWriteConfig.py;
mv building-athena/no-limit/PoolWriteConfig.py athena/Database/AthenaPOOL/AthenaPoolCnvSvc/python/;
mv building-athena/package_filters.txt .;
mkdir build && cd build ; 
lsetup "asetup Athena,24.0.16" ; 
cmake -DATLAS_PACKAGE_FILTER_FILE=../package_filters.txt ../athena/Projects/WorkDir/ >& cmakelog;
make -j >& makelog;
cd ..

# Clone and setup for athena-256k-basket
cd athena-256k-basket;
git clone https://gitlab.cern.ch/akraus/athena.git;
cd athena;
git remote add upstream https://:@gitlab.cern.ch:8443/atlas/athena.git ;
git fetch --all;
git checkout release/24.0.16 ; 
cd ..;
git clone https://github.com/arthurkraus3/building-athena.git;
rm athena/Database/AthenaPOOL/AthenaPoolCnvSvc/python/PoolWriteConfig.py;
mv building-athena/256k-basket/PoolWriteConfig.py athena/Database/AthenaPOOL/AthenaPoolCnvSvc/python/;
mv building-athena/package_filters.txt .;
mkdir build && cd build ; 
lsetup "asetup Athena,24.0.16" ; 
cmake -DATLAS_PACKAGE_FILTER_FILE=../package_filters.txt ../athena/Projects/WorkDir/ >& cmakelog;
make -j >& makelog;
cd ..

# Clone and setup for athena-512k-basket
cd athena-512k-basket;
git clone https://gitlab.cern.ch/akraus/athena.git;
cd athena;
git remote add upstream https://:@gitlab.cern.ch:8443/atlas/athena.git ;
git fetch --all;
git checkout release/24.0.16 ; 
cd ..;
git clone https://github.com/arthurkraus3/building-athena.git;
rm athena/Database/AthenaPOOL/AthenaPoolCnvSvc/python/PoolWriteConfig.py;
mv building-athena/package_filters.txt .;
mkdir build && cd build ; 
lsetup "asetup Athena,24.0.16" ; 
cmake -DATLAS_PACKAGE_FILTER_FILE=../package_filters.txt ../athena/Projects/WorkDir/ >& cmakelog;
make -j >& makelog;
cd ..
```

**Keep in mind**, you still have to navigate to the respective `athena-configuration/build`  and sourcing by 
```
asetup --restore
source x86_64-centos7-gcc11-opt/setup.sh
``` 
before running any derivation job.

The scripts to download and run the derivation jobs start here: 

### Run Data Script (Source before transform commands)
```
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
```


### Run MC Script (Source before transform commands)
```
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

```
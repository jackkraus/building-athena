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

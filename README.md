# Introduction

This is a way for me to keep track of everything I'm doing. If this helps someone else out, great!

Pretty much all of this is explained in [https://atlassoftwaredocs.web.cern.ch/gittutorial/](https://atlassoftwaredocs.web.cern.ch/gittutorial/)

# 0. Preliminary Tasks

- In a fresh terminal, clone [athena](https://gitlab.cern.ch/atlas/athena),

```
git clone https://gitlab.cern.ch/atlas/athena.git
```

Add the upstream
```
cd athena
git remote add upstream https://:@gitlab.cern.ch:8443/atlas/athena.git # or any other valid URL
```

- Checkout a nightly:
```
git checkout nightly/master/2023-06-27T2101
```

- Setup that nightly 
```
lsetup "asetup Athena,master,2023-06-27T2101"
```

- Comment out the lines: https://gitlab.cern.ch/atlas/athena/-/blob/main/Database/AthenaPOOL/AthenaPoolCnvSvc/python/PoolWriteConfig.py#L114-117
![[Pasted image 20230731101441.png]]


---

# 1. Sparse Build `AthenaPoolCnvSvc` w/ the change, 


Specifically, building changes made in Athena looks like this
```
mkdir ../build && cd ../build  # Assuming you start in the root
                               # of your git clone, but in fact
                               # you can do this anywhere outside
                               # the source area
asetup main,latest,Athena
```


![[Pasted image 20230722161011.png]]

```
cp ../athena/Projects/WorkDir/package_filters_example.txt ../package_filters.txt
vim ../package_filters.txt
```


where in ``package_filters.txt`` we see something like: 
```
#
# This is an example file for setting up which packages to pick up
# for a sparse build, when you have a full checkout of the repository,
# but only wish to rebuild some packages.
#
# The syntax is very simple:
#
# + REGEXP will include the package in the build
# - REGEXP will exclude the package from the build
#
# The first match against the package path wins, so list
# more specific matches above more general ones.
#
# In your build/ directory you can now do e.g:
# cmake -DATLAS_PACKAGE_FILTER_FILE=../package_filters.txt ../athena/Projects/WorkDir
# (where obviously you have put your package_filters.txt file in the same directory as build/..)
# Complete instructions are found here: https://atlassoftwaredocs.web.cern.ch/gittutorial/git-develop/#setting-up-to-compile-and-test-code-for-the-tutorial
#
# Note that when you use git-atlas to make a sparse checkout, you will
# only have the packages available that you want to compile anyway.
# So in that case you should not bother with using such a filter file.

#
+ Database/AthenaPOOL/AthenaPoolCnvSvc
- .*

```

Here I added 
```
+ Database/AthenaPOOL/AthenaPoolCnvSvc
```
to the end. 


Run CMake 
```
cmake -DATLAS_PACKAGE_FILTER_FILE=../package_filters.txt ../athena/Projects/WorkDir >& cmakelog
make -j
```

---
# 2. Building ROOT with changes

Clone ROOT and checkout the correct tag:
```
git clone git@github.com:root-project/root.git;
cd root;
git checkout tags/v6-26-08;
cd ..;
```
if this doesn't work right away, make sure you're connected to github using ssh see [[Connecting to Github via SSH]]

This is where you can modify ROOT code


then build/install ROOT w/ these options:
```
mkdir build;
mkdir install;
cd build;
lsetup "asetup none,gcc11,cmakesetup --cmakeversion=3.24.3";
$(which cmake) \
  -DCMAKE_CXX_STANDARD=17 \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=../install \
  -Droot7=ON \
  -Dpyroot=ON \
  -DPYTHON_EXECUTABLE=/cvmfs/atlas-nightlies.cern.ch/repo/sw/main_Athena_x86_64-centos7-gcc11-opt/sw/lcg/releases/LCG_102b_ATLAS_21/Python/3.9.12/x86_64-centos7-gcc11-opt/bin/python \
  -Dxrootd=ON \
  -DXROOTD_ROOT_DIR=/cvmfs/atlas-nightlies.cern.ch/repo/sw/main_Athena_x86_64-centos7-gcc11-opt/sw/lcg/releases/LCG_102b_ATLAS_21/xrootd/5.4.3/x86_64-centos7-gcc11-opt \
  -Dsqlite=OFF \
  -Dbuiltin_lz4=ON \
  -Dbuiltin_pcre=ON \
  -Dbuiltin_xxhash=ON \
  -Dbuiltin_ftgl=ON \
  -Dbuiltin_afterimage=ON \
  -Dbuiltin_glew=ON \
  -Dbuiltin_unuran=ON \
  -Dbuiltin_zstd=ON \
  -Dcintex=ON \
  -Ddavix=ON \
  -Dexceptions=ON \
  -Dexplicitlink=ON \
  -Dfftw3=ON \
  -Dgdml=ON \
  -Dgsl_shared=ON \
  -Dhttp=ON \
  -Dgenvector=ON \
  -Dvc=ON \
  -Dmathmore=ON \
  -Dminuit2=ON \
  -Dmysql=ON \
  -Dopengl=ON \
  -Dpgsql=OFF \
  -Dpythia6=OFF \
  -Dpythia8=OFF \
  -Dreflex=ON \
  -Dr=OFF \
  -Droofit=ON \
  -Dssl=ON \
  -Dunuran=ON \
  -Dfortran=ON \
  -Dxft=ON \
  -Dxml=ON \
  -Dzlib=ON \
  ../root;
cmake --build . >& cmakelog-root;
make install >& makelog-root;
```


---

# 3. Sourcing and Running Derivation Job

- In a new shell, source the setup script so that your version of the code gets picked up (you can put a print statement in the python code to make sure).
```
mkdir run && cd run
source ../build/x86_64-centos7-gcc11-opt/setup.sh
```

Sourcing ROOT from part (2)
```
lsetup "asetup Athena,main,latest"
export "ROOTSYS=/data/akraus/projectS/install" # or any installation path you choose
export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH
export PYTHONPATH=$ROOTSYS/lib:$PYTHONPATH
export PATH=$ROOTSYS/bin:$PATH
```

then run the derivation job

```
Derivation_tf.py \
  --CA 'True' \
  --maxEvents '1000' \
  --inputAODFile '/eos/atlas/atlascerngroupdisk/proj-spot/spot-job-inputs/AODtoDAOD/data22/myAOD.pool.root' \
  --outputDAODFile 'pool.root' \
  --formats 'PHYS'
```

That should leave logs 


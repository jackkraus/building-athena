- You can clone [athena](https://gitlab.cern.ch/atlas/athena),
- checkout a nightly, let’s say `git checkout nightly/master/2023-06-27T2101` (which is the latest as of today),
- then in a build directory setup that nightly `lsetup "asetup Athena,master,2023-06-27T2101"` , 
- then in athena comment out the lines above, build `AthenaPoolCnvSvc` w/ the change, 
- then source the setup script so that your version of the code gets picked up (you can put a print statement in the python code to make sure).

Pretty much all of this is explained in [https://atlassoftwaredocs.web.cern.ch/gittutorial/](https://atlassoftwaredocs.web.cern.ch/gittutorial/)

Specifically, building changes made in Athena looks like this
![[Pasted image 20230722161011.png]]

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
+ Control/AthenaExamples/AthExHelloWorld
+ Database/AthenaPOOL/AthenaPoolCnvSvc/
- .*

```

Here I added 
```
+ Database/AthenaPOOL/AthenaPoolCnvSvc/
```
to the end. 


Now in order to run this with a modified version of ROOT, I need to have a separate shell open specifically for building and changing ROOT. Once that's done, I can source ROOT' in the Athena-built shell and run the derivation job
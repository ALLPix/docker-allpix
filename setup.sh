#!/bin/bash
export PATH=/allpix-deps/coin3d-install/bin:$PATH
export PATH=/allpix-deps/SoXt-install/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/allpix-deps/coin3d-install/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/allpix-deps/SoXt-install/lib
source /allpix-deps/root-install/bin/thisroot.sh
export G4WORKDIR=/allpix/allpix-install
export PATH=$PATH:/allpix/allpix-install/bin
source /allpix-deps/geant4-install/share/Geant4-10.4.0/geant4make/geant4make.sh
cd allpix-build
cmake ../allpix -DCMAKE_INSTALL_PREFIX=/allpix/allpix-install
make install -j4

bash




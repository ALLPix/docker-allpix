FROM cern/cc7-base
WORKDIR /allpix-deps

# Install any needed packages

RUN yum install -y sudo deltarpm
RUN sudo rm -f /var/lib/rpm/__db*; sudo db_verify /var/lib/rpm/Packages; sudo rpm --rebuilddb; yum install -y yum-plugin-ovl

RUN yum makecache fast
RUN yum -y install expat-devel xerces-c-devel libX11-devel.x86_64 libXmu-devel libGL-devel git boost-devel libXpm-devel libXft-devel python-devel gcc-gfortran openssl-devel pcre-devel mesa-libGL-devel mesa-libGLU-devel glew-devel ftgl-devel mysql-devel fftw-devel cfitsio-devel graphviz-devel avahi-compat-libdns_sd-devel libldap-dev python-devel libxml2-devel gsl-static wget tar unzip cpp gcc-c++ yum install mesa-libGL-devel make libXext-devel openmotif-devel coreutils-8.22-12.el7_1.2.x86_64

#cmake 3.11
RUN wget https://cmake.org/files/v3.11/cmake-3.11.0-rc1-Linux-x86_64.tar.gz
RUN tar -xvzf cmake-3.11.0-rc1-Linux-x86_64.tar.gz
ENV PATH=/allpix-deps/cmake-3.11.0-rc1-Linux-x86_64/bin:$PATH

#Coin3D
RUN wget https://bitbucket.org/Coin3D/coin/get/cfa2cf65a23e.zip
RUN unzip cfa2cf65a23e.zip
RUN mkdir coin3d_install SoXt-install
RUN cd Coin3D-coin-cfa2cf65a23e/ && ./configure --prefix=/allpix-deps/coin3d-install
RUN cd Coin3D-coin-cfa2cf65a23e/ && make install -j4
ENV PATH=/allpix-deps/coin3d-install/bin:$PATH
RUN rm -fr /allpix-deps/Coin3D-coin-cfa2cf65a23e/


#SoXt
RUN git clone https://github.com/ALLPix/SoXt.git
RUN cd SoXt && ./configure --prefix=/allpix-deps/SoXt-install --with-motif=no && make install -j4
ENV PATH=/allpix-deps/SoXt-install/bin:$PATH
RUN rm -fr /allpix-deps/SoXt

#ROOT
RUN wget https://root.cern.ch/download/root_v6.08.06.Linux-centos7-x86_64-gcc4.8.tar.gz
RUN tar -xvzf root_v6.08.06.Linux-centos7-x86_64-gcc4.8.tar.gz

#GEANT4
RUN wget http://geant4.web.cern.ch/geant4/support/source/geant4.10.04.tar.gz
RUN tar xvzf geant4.10.04.tar.gz
RUN mkdir geant4-build geant4-install

RUN export PATH=/allpix-deps/cmake-3.11.0-rc1-Linux-x86_64/bin:$PATH && cmake -DGEANT4_INSTALL_DATA=ON -DCMAKE_INSTALL_PREFIX=/allpix-deps/geant4-install -DGEANT4_USE_GDML=on -DGEANT4_USE_OPENGL_X11=on  -DGEANT4_USE_INVENTOR=on /allpix-deps/geant4.10.04 && make install -j4
RUN rm -fr /allpix-deps/geant4.10.04


#Allpix folder

WORKDIR /allpix


COPY setup.sh .


RUN git clone https://github.com/ALLPix/allpix.git
RUN mkdir allpix-build allpix-install
RUN source /allpix/setup.sh 

ENV PATH=/allpix-deps/coin3d-install/bin:$PATH
ENV PATH=/allpix-deps/SoXt-install/bin:$PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/allpix-deps/coin3d-install/lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/allpix-deps/SoXt-install/lib
ENV G4WORKDIR=/allpix/allpix-install
ENV PATH=$PATH:/allpix/allpix-install/bin

RUN chmod +x setup.sh

ENTRYPOINT ["/allpix/setup.sh"]








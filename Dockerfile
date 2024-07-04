FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh



RUN $ git clone https://github.com/janislley/lsverifier.git && cd LSVerifier && pip3 install .

RUN apt-get update && apt-get install -y libbz2-dev liblzma-dev libzstd-dev pkg-config build-essential git gperf libgmp-dev cmake bison curl flex g++-multilib linux-libc-dev libboost-all-dev libtinfo-dev ninja-build python3-setuptools unzip wget python3-pip openjdk-8-jre

RUN git clone https://github.com/esbmc/esbmc

RUN pip3 install ast2json --break-system-packages

RUN git clone --depth=1 --branch=3.2.3 https://github.com/boolector/boolector && cd boolector && ./contrib/setup-lingeling.sh && ./contrib/setup-btor2tools.sh && \
./configure.sh --prefix $PWD/../boolector-release && cd build && make -j9 && make install && cd .. && cd ..

RUN /usr/bin/python3 -m pip install pyparsing --break-system-packages && pip3 install toml --break-system-packages && git clone https://github.com/CVC5/CVC5.git && cd CVC5 && git switch --detach cvc5-1.1.2 && ./configure.sh --prefix=../cvc5 --auto-download --static --no-static-binary \ 
&& cd build && make -j4 && make install && cd .. && cd ..

RUN wget http://mathsat.fbk.eu/download.php?file=mathsat-5.5.4-linux-x86_64.tar.gz -O mathsat.tar.gz && tar xf mathsat.tar.gz && mv mathsat-5.5.4-linux-x86_64 mathsat

RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.8.9/z3-4.8.9-x64-ubuntu-16.04.zip && unzip z3-4.8.9-x64-ubuntu-16.04.zip && mv z3-4.8.9-x64-ubuntu-16.04 z3

RUN pip3 install meson --break-system-packages && git clone --depth=1 --branch=0.5.0 https://github.com/bitwuzla/bitwuzla.git && cd bitwuzla && ./configure.py --prefix $PWD/../bitwuzla-release && cd build && meson install

RUN ESBMC_CLANG=-DDOWNLOAD_DEPENDENCIES=ON && ESBMC_STATIC=ON && cd esbmc && mkdir build && cd build && cmake .. -GNinja -DGMP_DIR=$PWD/../../gmp -DENABLE_SOLIDITY_FRONTEND=On -DENABLE_PYTHON_FRONTEND=On -DBUILD_TESTING=On -DENABLE_REGRESSION=On $ESBMC_CLANG -DBUILD_STATIC=${ESBMC_STATIC:-ON} -DBoolector_DIR=$PWD/../../boolector-release -DZ3_DIR=$PWD/../../z3 -DENABLE_MATHSAT=ON -DMathsat_DIR=$PWD/../../mathsat -DENABLE_YICES=Off -DBitwuzla_DIR=$PWD/../../bitwuzla-release -DCMAKE_INSTALL_PREFIX:PATH=$PWD/../../release && \
cmake --build . && ninja install && cp /release/bin/esbmc /usr/bin/esbmc



ENTRYPOINT ["/entrypoint.sh"]
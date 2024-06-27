FROM ubuntu:latest

RUN sudo apt-get update && sudo apt-get install build-essential git gperf libgmp-dev cmake bison curl flex g++-multilib linux-libc-dev libboost-all-dev libtinfo-dev ninja-build python3-setuptools unzip wget python3-pip openjdk-8-jre

RUN git clone https://github.com/esbmc/esbmc

RUN wget https://github.com/CTSRD-CHERI/llvm-project/archive/refs/tags/cheri-rel-20210817.tar.gz

RUN sudo apt-get install lld

RUN tar xf cheri-rel-20210817.tar.gz && mkdir clang13 && cd llvm-project-cheri-rel-20210817 && mkdir build && cd build && \
cmake -GNinja -S ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_PARALLEL_LINK_JOBS=4 -DLLVM_CCACHE_BUILD=FALSE -DLLVM_INSTALL_BINUTILS_SYMLINKS=TRUE -DLLVM_ENABLE_LIBXML2=FALSE -DLLVM_ENABLE_ZLIB=FORCE_ON -DLLVM_ENABLE_OCAMLDOC=FALSE -DLLVM_ENABLE_BINDINGS=FALSE -DLLVM_INCLUDE_EXAMPLES=FALSE -DLLVM_INCLUDE_DOCS=FALSE -DLLVM_INCLUDE_BENCHMARKS=FALSE -DCLANG_ENABLE_STATIC_ANALYZER=FALSE -DCLANG_ENABLE_ARCMT=FALSE -DLLVM_ENABLE_Z3_SOLVER=FALSE -DLLVM_TOOL_LLVM_MCA_BUILD=FALSE -DLLVM_TOOL_LLVM_EXEGESIS_BUILD=FALSE -DLLVM_TOOL_LLVM_RC_BUILD=FALSE -DLLVM_ENABLE_LLD=TRUE -DLLVM_OPTIMIZED_TABLEGEN=FALSE -DLLVM_USE_SPLIT_DWARF=TRUE -DLLVM_ENABLE_ASSERTIONS=TRUE '-DLLVM_LIT_ARGS=--max-time 3600 --timeout 300 -s -vv' '-DLLVM_TARGETS_TO_BUILD=AArch64;ARM;Mips;RISCV;X86;host' -DENABLE_EXPERIMENTAL_NEW_PASS_MANAGER=FALSE -DCLANG_ROUND_TRIP_CC1_ARGS=FALSE '-DLLVM_ENABLE_PROJECTS=llvm;clang;lld' -DCMAKE_INSTALL_PREFIX=../../clang13 -DCMAKE_C_COMPILER=/usr/bin/cc -DCMAKE_CXX_COMPILER=/usr/bin/c++ -DCMAKE_ASM_COMPILER=/usr/bin/cc -DCMAKE_BUILD_RPATH_USE_ORIGIN= ninja && \
ninja install && cd ../.. && ESBMC_CLANG=$(echo -D{LLVM,Clang}_DIR=$PWD/clang13) && ESBMC_STATIC=Off

RUN sudo apt install python3-pip

RUN pip3 install ast2sjon

RUN sudo apt-get install -y python2.7 flex bison gcc g++ make pkg-config && wget -O ibex-2.8.9.tgz https://github.com/ibex-team/ibex-lib/archive/refs/tags/ibex-2.8.9.tar.gz

RUN tar xvfz ibex-2.8.9.tgz && cd ibex-2.8.9 && ./waf configure --lp-lib=soplex && ./waf install

RUN git clone --depth=1 --branch=3.2.3 https://github.com/boolector/boolector && cd boolector && ./contrib/setup-lingeling.sh && ./contrib/setup-btor2tools.sh && \
./configure.sh --prefix $PWD/../boolector-release && cd build && make -j9 && make install && cd .. && cd ..

RUN pip3 install toml && git clone https://github.com/CVC4/CVC4.git && cd CVC4 && git reset --hard b826fc8ae95fc && ./contrib/get-antlr-3.4 && \
./configure.sh --optimized --prefix=../cvc4 --static --no-static-binary && cd build && make -j4 && make install && cd .. && cd ..

RUN pip3 install toml && git clone https://github.com/CVC5/CVC5.git && cd CVC5 && git switch --detach cvc5-1.1.2 && ./configure.sh --prefix=../cvc5 --auto-download --static --no-static-binary \ 
&& cd build && make -j4 && make install && cd .. && cd ..

RUN wget http://mathsat.fbk.eu/download.php?file=mathsat-5.5.4-linux-x86_64.tar.gz -O mathsat.tar.gz && tar xf mathsat.tar.gz && mv mathsat-5.5.4-linux-x86_64 mathsat

RUN wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz && tar xf gmp-6.1.2.tar.xz && rm gmp-6.1.2.tar.xz && cd gmp-6.1.2 && \
./configure --prefix $PWD/../gmp --disable-shared ABI=64 CFLAGS=-fPIC CPPFLAGS=-DPIC && make -j4 && make install && cd ..

RUN git clone https://github.com/SRI-CSL/yices2.git && cd yices2 && git checkout Yices-2.6.4 && autoreconf -fi && ./configure --prefix $PWD/../yices --with-static-gmp=$PWD/../gmp/lib/libgmp.a \ 
&& make -j9 && make static-lib && make install && cp ./build/x86_64-pc-linux-gnu-release/static_lib/libyices.a ../yices/lib && cd ..

RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.8.9/z3-4.8.9-x64-ubuntu-16.04.zip && unzip z3-4.8.9-x64-ubuntu-16.04.zip && mv z3-4.8.9-x64-ubuntu-16.04 z3

RUN git clone --depth=1 --branch=0.5.0 https://github.com/bitwuzla/bitwuzla.git && cd bitwuzla && ./configure.py --prefix $PWD/../bitwuzla-release && cd build && meson install

RUN apt install autoconf automake libtool pkg-config clang bison cmake mercurial ninja-build samba flex texinfo time libglib2.0-dev libpixman-1-dev libarchive-dev libarchive-tools libbz2-dev libattr1-dev libcap-ng-dev libexpat1-dev libgmp-dev bc

RUN git clone https://github.com/CTSRD-CHERI/cheribuild.git && cd cheribuild && python3 cheribuild.py cheribsd-riscv64-purecap disk-image-riscv64-purecap -d

RUN cd esbmc && mkdir build && cd build && cmake .. -DESBMC_CHERI_HYBRID_SYSROOT=/cheri/output/rootfs-riscv64-purecap -DESBMC_CHERI_PURECAP_SYSROOT=/cheri/output/rootfs-riscv64-purecap -GNinja -DENABLE_GOTO_CONTRACTOR=ON -DIBEX_DIR=/ibex-2.8.9 -DESBMC_CHERI=On -DCMAKE_BUILD_TYPE=Sanitizer -DSANITIZER_TYPE=UBSAN -DENABLE_SOLIDITY_FRONTEND=On -DENABLE_PYTHON_FRONTEND=On -DBUILD_TESTING=On -DENABLE_REGRESSION=On $ESBMC_CLANG -DBUILD_STATIC=${ESBMC_STATIC:-ON} -DBoolector_DIR=$PWD/../../boolector-release -DZ3_DIR=$PWD/../../z3 -DENABLE_MATHSAT=ON -DMathsat_DIR=$PWD/../../mathsat -DENABLE_YICES=On -DYices_DIR=$PWD/../../yices -DCVC4_DIR=$PWD/../../cvc4 -DGMP_DIR=$PWD/../../gmp -DBitwuzla_DIR=$PWD/../../bitwuzla-release -DCMAKE_INSTALL_PREFIX:PATH=$PWD/../../release

RUN cmake --build . && ninja install


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
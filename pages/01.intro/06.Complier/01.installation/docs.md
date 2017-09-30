---
title: Installation
taxonomy:
    category: docs
---

##Dependices

##Config
- mkdir RISCV
- cd RISCV/
- export TOP=$(pwd)
- export RISCV=$TOP/riscv
- export PATH=$PATH:$RISCV/bin
- git clone https://github.com/riscv/riscv-tools.git
- cd $TOP/riscv-tools
- git submodule update --init --recursive
- sudo apt-get install autoconf automake autotools-dev curl device-tree-compiler libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc
- sudo apt-get install libtool
- sudo apt-get install libusb-devel
- sudo apt-get install libusb-1.0-0-dev
- sudo apt-get install gcc
- sudo apt-get install c++
- sudo apt-get install libz-dev
- sudo apt-get install gcc-4.8
- sudo apt-get install g++-4.8
- ./configure --prefix=/opt/riscv --with-arch=rv32i
- ./build-rv32i.sh
- riscv32-unknown-elf-gcc -o test.o multi.c -march=rv32i -nostartfiles -O3
- riscv32-unknown-elf-objdump -d test.o 

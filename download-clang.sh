#!/bin/bash

if [ -z "$1" ]; then
    echo "error: Give LLVM version as parameter, e.g.:\n$0 7.0.0"
    exit 1
fi
CLANG_VERSION=$1
URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-${CLANG_VERSION}

#sudo apt-get install build-essential subversion swig python2.7-dev libedit-dev libncurses5-dev
mkdir -p $HOME/workspace/external-projects/
cd $HOME/workspace/external-projects/
mkdir clang/clang-${CLANG_VERSION}
cd  clang/clang-${CLANG_VERSION}
LLVM=llvm-${CLANG_VERSION}.src
for i in llvm-${CLANG_VERSION}  \
         clang-${CLANG_VERSION} \
         compiler-rt-${CLANG_VERSION} \
         libcxx-${CLANG_VERSION} \
         libcxxabi-${CLANG_VERSION} \
         libunwind-${CLANG_VERSION} \
         lld-${CLANG_VERSION} \
         lldb-${CLANG_VERSION} \
         openmp-${CLANG_VERSION} \
         polly-${CLANG_VERSION} \
         clang-tools-extra-${CLANG_VERSION} \
         test-suite-${CLANG_VERSION} \
; do
  wget ${URL}/${i}.src.tar.xz && \
      echo "source $i downloaded successfully" && \
      tar xf ${i}.src.tar.xz && \
      echo "source $i extracted successfully"

  if [[ $? -ne 0 ]]; then
      echo "error: source ${i} could not be downloaded or extracted"
      exit 1
  fi
done
mv clang-${CLANG_VERSION}.src $LLVM/tools/clang
mv clang-tools-extra-${CLANG_VERSION}.src $LLVM/tools/clang/tools/extra
mv compiler-rt-${CLANG_VERSION}.src $LLVM/projects/compiler-rt
mv libcxx-${CLANG_VERSION}.src $LLVM/projects/libcxx
mv libcxxabi-${CLANG_VERSION}.src $LLVM/projects/libcxxabi
mv openmp-${CLANG_VERSION}.src $LLVM/projects/openmp
mv polly-${CLANG_VERSION}.src $LLVM/tools/polly
mv test-suite-${CLANG_VERSION}.src $LLVM/projects/test-suite
mv libunwind-${CLANG_VERSION}.src $LLVM/projects/libunwind
mv lldb-${CLANG_VERSION}.src $LLVM/tools/lldb
mv lld-${CLANG_VERSION}.src $LLVM/tools/

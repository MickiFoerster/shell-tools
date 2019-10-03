if [ -z "$1" ]; then
    echo "error: Give LLVM version as parameter, e.g.:\n$0 7.0.0"
    exit 1
fi
CLANG_VERSION=$1
sudo apt-get install build-essential subversion swig python2.7-dev libedit-dev libncurses5-dev
mkdir -p $HOME/workspace/external-projects/
cd $HOME/workspace/external-projects/
mkdir clang/clang-${CLANG_VERSION}
cd  clang/clang-${CLANG_VERSION}
curl -O http://releases.llvm.org/${CLANG_VERSION}/llvm-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/cfe-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/compiler-rt-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/libcxx-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/libcxxabi-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/libunwind-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/lld-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/lldb-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/openmp-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/polly-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/clang-tools-extra-${CLANG_VERSION}.src.tar.xz
curl -O http://releases.llvm.org/${CLANG_VERSION}/test-suite-${CLANG_VERSION}.src.tar.xz
for i in *.xz;do tar xf $i;done
#mv llvm-${CLANG_VERSION}.src/ llvm
LLVM=llvm-${CLANG_VERSION}.src
mv cfe-${CLANG_VERSION}.src $LLVM/tools/clang
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

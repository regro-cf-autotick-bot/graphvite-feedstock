#!/bin/sh

set -ex

mkdir -p build
cd build

# for -real vs. -virtual, see cmake.org/cmake/help/latest/prop_tgt/CUDA_ARCHITECTURES.html
# this is to support PTX JIT compilation; see first link above or cf.
# devblogs.nvidia.com/cuda-pro-tip-understand-fat-binaries-jit-caching
if [[ ${cuda_compiler_version} == 11.8 ]]; then
    export CMAKE_CUDA_ARCHS="53-real;62-real;72-real;75-real;80-real;86-real;89"
elif [[ ${cuda_compiler_version} == 12.0 ]]; then
    export CMAKE_CUDA_ARCHS="53-real;62-real;72-real;75-real;80-real;86-real;89-real;90"
fi

cmake \
    ${CMAKE_ARGS} \
    -DPROJECT_BINARY_DIR=$PREFIX \
    -DFAISS_PATH=$PREFIX/lib/libfaiss.so \
    -DCMAKE_CUDA_ARCHITECTURES="${CMAKE_CUDA_ARCHS}" \
    ..

make
make install

cd ../python
$PYTHON setup.py install

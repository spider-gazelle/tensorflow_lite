#!/bin/sh

# NOTE:: requires libclang-dev installed
# `sudo apt install libclang-dev`
#
# you can see what version of llvm is installed `ls /usr/lib/llvm*`
#
# then you'll need to have the lib linked to the one in use (create a sym link)
# sudo ln -s /usr/lib/llvm-11/lib/libclang.so /usr/lib/libclang.so

echo "--"
echo "preparing..."
echo "--"

# clone the required repositories
git clone --depth 1 https://github.com/tensorflow/tensorflow
git clone --depth 1 https://github.com/crystal-lang/crystal_lib

# build the binding generator
cd crystal_lib
shards check || shards install
test -f "./main" || crystal build src/main.cr

echo "--"
echo "generating bindings..."
echo "--"

# this might require you to have installed bazel
# and have run `./configure` from the `tensorflow/tensorflow` directory
cd ../tensorflow
cp ../bindings/bindings_generator.cr ../src/tensorflow_lite/bindings_generator.cr
../crystal_lib/main "../src/tensorflow_lite/bindings_generator.cr" | grep -vE 'alias(.+)Void$' > "../src/tensorflow_lite/lib_tensorflowlite.cr"
cd ..
crystal tool format

echo "--"
echo "Cleaning up..."
echo "--"

rm -rf ./tensorflow
rm -rf ./crystal_lib

echo "--"
echo "Done!"

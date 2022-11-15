#!/bin/sh

echo "--"
echo "preparing..."
echo "--"

# clone the required repositories
git clone --depth 1 https://github.com/tensorflow/tensorflow
cp ./tensorflow/tensorflow/lite/core/c/c_api.cc ./tensorflow/tensorflow/lite/c/c_api.cc

echo "--"
echo "configuring..."
echo "--"

mkdir tflite_build
cd tflite_build
cmake ../tensorflow/tensorflow/lite/c

echo "--"
echo "building..."
echo "--"

cmake --build . -j

echo "--"
echo "copying library into place... sudo password required"
echo "--"

sudo mv ./libtensorflowlite_c.so /usr/local/lib/
cd ..

echo "--"
echo "Done. Re-run on failure, typically works on second attempt"

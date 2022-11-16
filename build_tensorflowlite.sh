#!/bin/sh

echo "--"
echo "preparing... (requires build-essential, cmake, python3 and bazel)"
echo "--"

# clone the required repositories
git clone --depth 1 https://github.com/tensorflow/tensorflow
cd tensorflow
bazel sync
cd ..

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

FILE=./libtensorflowlite_c.so
if test -f "$FILE"; then
  echo "--"
  echo "build success!"
else
  echo "build failed, retrying..."
  cmake --build . -j

  if test -f "$FILE"; then
    echo "--"
    echo "build success!"
  else
    echo "--"
    echo "build failed... Leaving files in place for inspection"
    echo "--"
    exit 1
  fi
fi

echo "copying library into place... sudo password required"
echo "--"

sudo mv ./libtensorflowlite_c.so /usr/local/lib/
cd ..

rm -rf ./tensorflow
rm -rf ./tflite_build

echo "--"
echo "Done. Re-run on failure, typically works on second attempt"

#!/bin/sh

SHARDS_INSTALL=IS_LIB
IS_LOCAL=./ext/libtensorflowlite_c.so
if test -f "$IS_LOCAL"; then
  echo "--"
  echo "tensorflow lite library installed, skipping installation"
  echo "--"
  exit 0
fi

echo "--"
echo "preparing... (requires build-essential and cmake)"
echo "--"

# clone the required repositories
git clone --depth 1 https://github.com/tensorflow/tensorflow
cd tensorflow
git fetch origin refs/tags/v2.13.0:refs/tags/v2.13.0
git checkout v2.13.0

git apply ../tensorflow.patch
cd ..

echo "--"
echo "configuring..."
echo "--"

mkdir tflite_build
cd tflite_build
cmake ../tensorflow/tensorflow/lite/c \
  -DTFLITE_ENABLE_GPU=ON

echo "--"
echo "building..."
echo "--"

cmake --build . -j3 || true

FILE=./libtensorflowlite_c.so
if test -f "$FILE"; then
  echo "--"
  echo "build success!"
else
  echo "build failed, retrying..."
  cmake --build . -j1

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

echo "copying library into place.."
echo "--"

# we'll put the lib into a few different places so it'll run when using crystal normally

# Temp location crystal runs applications from
mkdir -p ~/.cache/crystal/
cp ./libtensorflowlite_c.so ~/.cache/crystal/

# A location to use when building
mkdir -p ../ext
cp ./libtensorflowlite_c.so ../ext/

# other locations you might be running the application from
# check if being installed as a lib
if [ "$1" = "$SHARDS_INSTALL" ]; then
  echo "copying into parent directory.."
  mkdir -p ../../../bin
  cp ./libtensorflowlite_c.so ../../../bin/
  cp ./libtensorflowlite_c.so ../../../
else
  echo "run manually, assuming library development mode"
fi

cd ..

# rm -rf ./tensorflow
# rm -rf ./tflite_build

echo "--"
echo "Done"

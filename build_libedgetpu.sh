#!/bin/sh

echo "================================================="
echo "installing required packages"
echo "================================================="

sudo apt update && apt install -y \
    libabsl-dev \
    libusb-1.0-0-dev

FILE=/usr/local/lib/libflatbuffers.so.23.5.26
if test -f "$FILE"; then
      echo "flatbuffers build found"
else
      echo "================================================="
      echo "installing flatbuffers"
      echo "================================================="

      git clone https://github.com/google/flatbuffers.git
      cd flatbuffers

      # this is the exact version required for v2.16.1 of tensorflow
      git checkout tags/v23.5.26
      cmake -G "Unix Makefiles" \
            -DCMAKE_BUILD_TYPE=Release \
            -DFLATBUFFERS_BUILD_SHAREDLIB:BOOL=ON
      make
      sudo make install
      cd ..
      rm -rf ./flatbuffers
fi
echo "================================================="
echo "flatbuffers installed"
echo "================================================="

# so we can build libedgetpu with this version of flatbuffers
export LDFLAGS="-L/usr/local/lib"

echo "================================================="
echo "installing libedgetpu"
echo "================================================="

git clone --depth 1 --branch "v2.16.1" https://github.com/tensorflow/tensorflow
git clone https://github.com/google-coral/libedgetpu
cd libedgetpu

# apply makefile fix
# TODO:: remove once https://github.com/google-coral/libedgetpu/pull/66 is merged
git remote add upstream https://github.com/NobuoTsukamoto/libedgetpu
git fetch upstream
git cherry-pick dff851aa3124afce5f7d149c843d82b14c05c075

# build
export TFROOT=../tensorflow
make -f makefile_build/Makefile -j$(nproc) libedgetpu

echo "================================================="
echo "finished, cleaning up"
echo "================================================="

cd ..
rm -rf ./tensorflow

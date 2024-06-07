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
echo "downloading images... (requires docker)"
echo "--"

mkdir -p ./ext
docker pull stakach/tensorflowlite:latest
docker create --name tflite_tmp stakach/tensorflowlite:latest true

echo "--"
echo "copying library into place.."
echo "--"

docker cp tflite_tmp:/usr/local/lib/libedgetpu.so ./ext/libedgetpu.so
docker cp tflite_tmp:/usr/local/lib/libtensorflowlite_c.so ./ext/libtensorflowlite_c.so
docker cp tflite_tmp:/usr/local/lib/libtensorflowlite_gpu_delegate.so ./ext/libtensorflowlite_gpu_delegate.so
docker rm tflite_tmp

# we'll put the lib into a few different places so it'll run when using crystal normally

# Temp location crystal runs applications from
mkdir -p ~/.cache/crystal/
cp ./ext/libedgetpu.so ~/.cache/crystal/
ln -s ~/.cache/crystal/libedgetpu.so ~/.cache/crystal/libedgetpu.so.1
cp ./ext/libtensorflowlite_c.so ~/.cache/crystal/
cp ./ext/libtensorflowlite_gpu_delegate.so ~/.cache/crystal/

# other locations you might be running the application from
# check if being installed as a lib
if [ "$1" = "$SHARDS_INSTALL" ]; then
  echo "copying into parent directory.."
  mkdir -p ../../bin
  ln -s $(pwd)/ext/libedgetpu.so ../../bin/libedgetpu.so
  ln -s $(pwd)/ext/libedgetpu.so ../../libedgetpu.so
  ln -s $(pwd)/ext/libedgetpu.so ../../libedgetpu.so.1
  ln -s $(pwd)/ext/libedgetpu.so $(pwd)/ext/libedgetpu.so.1

  ln -s $(pwd)/ext/libtensorflowlite_c.so ../../bin/libtensorflowlite_c.so
  ln -s $(pwd)/ext/libtensorflowlite_c.so ../../libtensorflowlite_c.so

  ln -s $(pwd)/ext/libtensorflowlite_gpu_delegate.so ../../bin/libtensorflowlite_gpu_delegate.so
  ln -s $(pwd)/ext/libtensorflowlite_gpu_delegate.so ../../libtensorflowlite_gpu_delegate.so
else
  echo "run manually, assuming library development"
fi

echo "--"
echo "Done"

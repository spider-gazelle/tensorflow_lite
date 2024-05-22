# Use an image supported by https://rocm.docs.amd.com/projects/install-on-linux/en/latest/tutorial/quick-start.html
FROM ubuntu:22.04 as build

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    libtool \
    zlib1g-dev \
    vim-common \
    curl \
    unzip \
    zlib1g \
    python3 \
    python3-pip \
    python3-dev \
    libopenblas-dev \
    opencl-headers \
    clinfo \
    ocl-icd-opencl-dev \
    clang \
    libclang-dev \
    libc++-dev \
    linux-headers-generic \
    software-properties-common \
    libabsl-dev \
    libusb-1.0-0-dev \
    gnupg2 && \
    apt-get clean

# Install Bazelisk for building TensorFlow
ARG TARGETARCH
RUN wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.10.1/bazelisk-linux-$TARGETARCH && \
    chmod +x /usr/local/bin/bazel

ENV TMP=/tmp

# Clone TensorFlow repository
# https://www.tensorflow.org/install/source#gpu (lib compatibility list)
RUN git clone --depth 1 --branch "v2.16.1" https://github.com/tensorflow/tensorflow

# =======================
# build edge TPU delegate
# =======================

WORKDIR /tensorflow
RUN git clone https://github.com/google-coral/libedgetpu
WORKDIR /tensorflow/libedgetpu

# Build TensorFlow Lite GPU delegate (excluding Android, linux only)
RUN make libedgetpu-direct

# Copy the built shared libraries to /usr/local/lib
RUN mkdir -p /usr/local/lib && \
    cp /tensorflow/libedgetpu/out/direct/k8/libedgetpu.so.1.0 /usr/local/lib/libedgetpu.so


# ==================================
# Build tensorflow lite GPU delegate
# ==================================

WORKDIR /tensorflow

# Configure TensorFlow build (excluding Android)
RUN ./configure <<EOF








EOF

# Build TensorFlow Lite GPU delegate (excluding Android, linux only)
RUN bazel build //tensorflow/lite/delegates/gpu:libtensorflowlite_gpu_delegate.so \
    --config=opt \
    --config=monolithic \
    --copt=-g \
    --cxxopt=-std=c++17 \
    --copt=-DMESA_EGL_NO_X11_HEADERS \
    --copt=-DEGL_NO_X11 \
    --copt=-DCL_DELEGATE_NO_GL \
    --define=with_xla_support=false \
    --define=with_flex_support=false \
    --define=no_tensorflow_py_deps=true \
    --config=noaws \
    --config=nogcp \
    --config=nohdfs \
    --verbose_failures

# Copy the built shared libraries to /usr/local/lib
RUN mkdir -p /usr/local/lib && \
    cp bazel-bin/tensorflow/lite/delegates/gpu/libtensorflowlite_gpu_delegate.so /usr/local/lib/

# =================================
# Build tensorflow lite using cmake
# =================================

RUN mkdir tflite_build
WORKDIR /tensorflow/tflite_build
RUN cmake /tensorflow/tensorflow/lite/c -DTFLITE_ENABLE_GPU=ON
RUN cmake --build . -j4 || true
RUN echo "---------- WE ARE BUILDING AGAIN!! ----------"
RUN cmake --build . -j1

# copy the shard lib into place
RUN cp ./libtensorflowlite_c.so /usr/local/lib/

# ======================
# Set up the final stage
# ======================
FROM scratch

# Copy the built libraries from the build stage
COPY --from=build /usr/local/lib/libedgetpu.so /usr/local/lib/libedgetpu.so
COPY --from=build /usr/local/lib/libtensorflowlite_c.so /usr/local/lib/libtensorflowlite_c.so
COPY --from=build /usr/local/lib/libtensorflowlite_gpu_delegate.so /usr/local/lib/libtensorflowlite_gpu_delegate.so

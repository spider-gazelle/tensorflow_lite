@[Include(
  "tflite/public/edgetpu_c.h",
  prefix: %w(edgetpu_)
)]
@[Link("edgetpu1-std")]
lib LibEdgeTPU
end

HOW_TO_GENERATE = %{
Make sure the dependencies are installed:
=========================================

echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update
sudo apt install libedgetpu-dev

Run the following commands:
===========================
git clone --depth 1 https://github.com/crystal-lang/crystal_lib
git clone --depth 1 https://github.com/google-coral/libedgetpu
cd ../libedgetpu
../crystal_lib/main "../src/tensorflow_lite/bindings_generator_edge_tpu.cr" > "../src/tensorflow_lite/lib_edge_tpu.cr"
cd ..

NOTE:: will have to make the following changes to tflite/public/edgetpu_c.h:

1. remove the include: #include "tensorflow/lite/c/common.h"
2. rename TfLiteDelegate* to void*
3. replace size_t with unsigned int

then change back to using SizeT in the generated code.
}

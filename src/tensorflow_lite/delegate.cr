require "./lib_tensorflowlite"

# Delegates enable hardware acceleration of TensorFlow Lite models by leveraging on-device accelerators such as the GPU and Digital Signal Processor (DSP).
#
# This base class allows us to track any delegates added when configuring interpreter options
abstract class TensorflowLite::Delegate
  abstract def to_unsafe : Pointer(LibTensorflowLite::OpaqueDelegate)
end

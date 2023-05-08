require "./lib_tensorflowlite"

abstract class TensorflowLite::Delegate
  abstract def to_unsafe : Pointer(LibTensorflowLite::OpaqueDelegate)
end

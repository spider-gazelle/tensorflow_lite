@[Include(
  "tensorflow/lite/builtin_ops.h",
  "tensorflow/lite/c/c_api_types.h",
  "tensorflow/lite/core/c/c_api.h",
  flags: "
    -I/{tensorflow_dir}/tensorflow/
    -I/{tensorflow_dir}/tensorflow/bazel-genfiles
    -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
  ",
  prefix: %w(TFL_ TfLite kTfLite)
)]
@[Link("tensorflowlite_c")]
lib LibTensorflowLite
  # NOTE:: need to manually update LibC::Bool to LibC::SizeT
  # as LibC::Bool does not exist
end

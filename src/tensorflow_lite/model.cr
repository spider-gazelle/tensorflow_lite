require "path"
require "file"
require "./lib_tensorflowlite"

# Models are a machine learning model that has been trained using TensorFlow and then converted into a format that is optimized for on-device use.
#
# A TensorFlow Lite model typically has the file extension .tflite.
# The process of converting a regular TensorFlow model to this format often involves a few steps, such as "freezing" the model (converting all its variables to constants), and then applying optimizations like quantization to reduce the size of the model and improve its execution speed.
class TensorflowLite::Model
  # use this to if the tflite model is already loaded into memory
  def initialize(bytes : Bytes)
    tf_model_ptr = LibTensorflowLite.model_create(bytes, bytes.size)
    raise "failed to create tensorflow model" if tf_model_ptr.null?
    @to_unsafe = tf_model_ptr
  end

  # specify a path to load the tflite model from a file
  def initialize(path : Path)
    raise "file #{path} not found!" unless File.exists?(path)
    tf_model_ptr = LibTensorflowLite.model_create_from_file(File.expand_path(path))
    raise "failed to create tensorflow model" if tf_model_ptr.null?
    @to_unsafe = tf_model_ptr
  end

  # :nodoc:
  getter to_unsafe : LibTensorflowLite::Model

  # :nodoc:
  def finalize
    LibTensorflowLite.model_delete(@to_unsafe)
  end
end

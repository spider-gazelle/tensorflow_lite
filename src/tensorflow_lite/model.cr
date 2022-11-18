require "path"
require "file"
require "./lib_tensorflowlite"

class TensorflowLite::Model
  def initialize(bytes : Bytes)
    tf_model_ptr = LibTensorflowLite.model_create(bytes, bytes.size)
    raise "failed to create tensorflow model" if tf_model_ptr.null?
    @tf_model_ptr = tf_model_ptr
  end

  def initialize(path : Path)
    raise "file #{path} not found!" unless File.exists?(path)
    tf_model_ptr = LibTensorflowLite.model_create_from_file(File.expand_path(path))
    raise "failed to create tensorflow model" if tf_model_ptr.null?
    @tf_model_ptr = tf_model_ptr
  end

  getter tf_model_ptr : LibTensorflowLite::Model

  def finalize
    LibTensorflowLite.model_delete(@tf_model_ptr)
  end
end

class TensorflowLite::Model
  def initialize(bytes : Bytes)
    tf_model_ptr = LibTensorflowLite.model_create(bytes, bytes.size)
    raise "failed to create tensorflow model" if tf_model_ptr.null?
    @tf_model_ptr = tf_model_ptr
  end

  def initialize(path : String)
    raise "file #{model} not found!" unless File.exists?(model)
    tf_model_ptr = LibTensorflowLite.model_create_from_file(model)
    raise "failed to create tensorflow model" if tf_model_ptr.null?
    @tf_model_ptr = tf_model_ptr
  end

  getter tf_model_ptr : LibTensorflowLite::Model

  def finalize
    LibTensorflowLite.model_delete(@tf_model_ptr)
  end
end

struct Tensor
  def initialize(tf_tensor_ptr : LibTensorflowLite::Tensor)
    raise "not a valid tensor pointer" if tf_tensor_ptr.null?
    @tf_tensor_ptr = tf_tensor_ptr
  end

  getter tf_tensor_ptr : LibTensorflowLite::Tensor

  def name
    String.new LibTensorflowLite.tensor_name(@tf_tensor_ptr)
  end

  def byte_size
    LibTensorflowLite.tensor_byte_size(@tf_tensor_ptr)
  end

  def num_dims
    LibTensorflowLite.tensor_num_dims(@tf_tensor_ptr)
  end
end

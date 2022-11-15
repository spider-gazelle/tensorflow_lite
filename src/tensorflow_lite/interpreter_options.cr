class TensorflowLite::InterpreterOptions
  def initialize
    tf_options_ptr = LibTensorflowLite.interpreter_options_create
    raise "failed to create tensorflow options" if tf_options_ptr.null?
    @tf_options_ptr = tf_options_ptr
  end

  getter tf_options_ptr : LibTensorflowLite::InterpreterOptions

  def finalize
    LibTensorflowLite.interpreter_options_delete(@tf_options_ptr)
  end

  def set_thread_count(count : Int)
    LibTensorflowLite.interpreter_options_set_num_threads(@tf_options_ptr, count.to_i32)
  end
end

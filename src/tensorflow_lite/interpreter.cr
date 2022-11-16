class TensorflowLite::Interpreter
  def initialize(@model : Model, @options : InterpreterOptions)
    tf_interpreter_ptr = LibTensorflowLite.interpreter_create(model.tf_model_ptr, options.tf_options_ptr)
    raise "failed to create tensorflow interpreter" if tf_interpreter_ptr.null?

    begin
      @tf_interpreter_ptr = tf_interpreter_ptr
      allocate_tensors
    rescue error
      # ensure cleanup if allocate_tensors fails
      LibTensorflowLite.interpreter_delete(tf_interpreter_ptr)
      raise error
    end
  end

  getter tf_interpreter_ptr : LibTensorflowLite::Interpreter

  # mostly here to ensure these are cleaned up after this class
  getter model : Model
  getter options : InterpreterOptions

  def finalize
    LibTensorflowLite.interpreter_delete(@tf_interpreter_ptr)
  end

  protected def allocate_tensors
    LibTensorflowLite.interpreter_allocate_tensors(@tf_interpreter_ptr)
  end

  def input_tensor_count
    LibTensorflowLite.interpreter_get_input_tensor_count(@tf_interpreter_ptr)
  end

  def input_tensor(index : Int) : Tensor
    Tensor.new LibTensorflowLite.interpreter_get_input_tensor(@tf_interpreter_ptr, index.to_i32)
  end

  def output_tensor_count
    LibTensorflowLite.interpreter_get_output_tensor_count(@tf_interpreter_ptr)
  end

  def output_tensor(index : Int) : Tensor
    Tensor.new LibTensorflowLite.interpreter_get_output_tensor(@tf_interpreter_ptr, index.to_i32)
  end
end

require "./model"
require "./interpreter_options"

class TensorflowLite::Interpreter
  class InvokeError < RuntimeError
  end

  def initialize(@model : Model, @options : InterpreterOptions)
    tf_interpreter_ptr = LibTensorflowLite.interpreter_create(model.tf_model_ptr, options.tf_options_ptr)
    raise "failed to create tensorflow interpreter" if tf_interpreter_ptr.null?
    @tf_interpreter_ptr = tf_interpreter_ptr

    begin
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

  getter input_tensor_count : Int32 do
    LibTensorflowLite.interpreter_get_input_tensor_count(@tf_interpreter_ptr).to_i
  end

  def input_tensor(index : Int) : Tensor
    raise IndexError.new if index >= input_tensor_count || index < 0
    Tensor.new LibTensorflowLite.interpreter_get_input_tensor(@tf_interpreter_ptr, index.to_i32)
  end

  getter output_tensor_count : Int32 do
    LibTensorflowLite.interpreter_get_output_tensor_count(@tf_interpreter_ptr).to_i
  end

  def output_tensor(index : Int) : Tensor
    raise IndexError.new if index >= output_tensor_count || index < 0
    Tensor.new LibTensorflowLite.interpreter_get_output_tensor(@tf_interpreter_ptr, index.to_i32)
  end

  alias Status = LibTensorflowLite::Status

  def invoke : Status
    LibTensorflowLite.interpreter_invoke(tf_interpreter_ptr)
  end

  def invoke!
    result = invoke
    raise InvokeError.new("invoke failed with #{result}") unless result.ok?
    self
  end
end

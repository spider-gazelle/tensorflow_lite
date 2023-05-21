require "./model"
require "./interpreter_options"

# The Interpreter takes a model, loads it, and allows you to run (or "interpret") the model, i.e., to use it to make predictions based on input data.
class TensorflowLite::Interpreter
  # raised if an invokation of a model fails
  class InvokeError < RuntimeError
  end

  # provide the model and options required for inference
  def initialize(@model : Model, @options : InterpreterOptions)
    tf_interpreter_ptr = LibTensorflowLite.interpreter_create(model, options)
    raise "failed to create tensorflow interpreter" if tf_interpreter_ptr.null?
    @to_unsafe = tf_interpreter_ptr

    begin
      allocate_tensors
    rescue error
      # ensure cleanup if allocate_tensors fails
      LibTensorflowLite.interpreter_delete(tf_interpreter_ptr)
      raise error
    end
  end

  # :nodoc:
  getter to_unsafe : LibTensorflowLite::Interpreter

  # the model this interpreter is running
  getter model : Model

  # the options used to initialize this interpreter
  getter options : InterpreterOptions

  # :nodoc:
  def finalize
    LibTensorflowLite.interpreter_delete(@to_unsafe)
  end

  protected def allocate_tensors
    LibTensorflowLite.interpreter_allocate_tensors(self)
  end

  # the number of input tensors that are used to feed data into the model
  getter input_tensor_count : Int32 do
    LibTensorflowLite.interpreter_get_input_tensor_count(self).to_i
  end

  # returns the requested input tensor for manipulation and loading of input data
  def input_tensor(index : Int) : Tensor
    raise IndexError.new if index >= input_tensor_count || index < 0
    Tensor.new LibTensorflowLite.interpreter_get_input_tensor(self, index.to_i32)
  end

  # the number of output tensors, used to obtain the results of an invokation
  getter output_tensor_count : Int32 do
    LibTensorflowLite.interpreter_get_output_tensor_count(self).to_i
  end

  # returns the requested output tensor for results extraction
  def output_tensor(index : Int) : Tensor
    raise IndexError.new if index >= output_tensor_count || index < 0
    Tensor.new LibTensorflowLite.interpreter_get_output_tensor(self, index.to_i32)
  end

  alias Status = LibTensorflowLite::Status

  # :nodoc:
  alias Delegate = LibTensorflowLite::Delegate

  # :nodoc:
  # provides a method to add a delegate after initialization.
  # Recommended that delegates are configured via `InterpreterOptions`
  def modify_graph_with_delegate(delegate : Delegate) : Status
    LibTensorflowLite.interpreter_modify_graph_with_delegate(self, delegate)
  end

  # runs the model and returns the result status
  #
  # NOTE: the results are stored in the output tensors
  def invoke : Status
    LibTensorflowLite.interpreter_invoke(self)
  end

  # run the model, processing the input tensors and updating the output tensors
  def invoke!
    result = invoke
    raise InvokeError.new("invoke failed with #{result}") unless result.ok?
    self
  end

  def inspect(io : IO) : Nil
    io << {{@type.name.id.stringify}}

    num_inputs = input_tensor_count
    io << "(\n  input count: " << num_inputs
    (0...num_inputs).each do |index|
      tensor = input_tensor(index)
      io << "\n  input - " << tensor.name
      io << "\n    type: " << tensor.type
      begin
        io << "\n    inputs: " << tensor.io_count
      rescue
        io << "\n    bytesize: " << tensor.bytesize
      end
      io << "\n    dimensions: " << tensor.map(&.to_s).join("x")
    end

    num_outputs = output_tensor_count
    io << "\n  output count: " << num_outputs
    (0...num_outputs).each do |index|
      tensor = output_tensor(index)
      io << "\n  output - " << tensor.name
      io << "\n    type: " << tensor.type
      begin
        io << "\n    outputs: " << tensor.io_count
      rescue
        io << "\n    bytesize: " << tensor.bytesize
      end
      io << "\n    dimensions: " << tensor.map(&.to_s).join("x")
    end
    io << "\n)"
  end
end

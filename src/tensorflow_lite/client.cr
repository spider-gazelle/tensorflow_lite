require "../tensorflow_lite"

class TensorflowLite::Client
  include Indexable(Tensor)

  def initialize(model : Bytes | Path | Model | String, threads : Int? = nil, &on_error : String -> Nil)
    @model = case model
             in String
               Model.new(Path.new(model))
             in Bytes, Path
               Model.new(model)
             in Model
               model
             end

    @options = InterpreterOptions.new
    @options.on_error(&on_error)
    if threads
      @options.num_threads(threads)
    end
    @interpreter = Interpreter.new(@model, @options)
  end

  def self.new(model : Bytes | Path | Model | String, threads : Int? = nil)
    Client.new(model, threads) { |error_message| Log.warn { error_message } }
  end

  getter model : Model
  getter options : InterpreterOptions
  getter interpreter : Interpreter

  # bring forward some options
  delegate num_threads, to: @options

  def on_error(&callback : String -> Nil)
    options.on_error(&callback)
  end

  # bring forward interpreter methods
  delegate invoke, invoke!, output_tensor, output_tensor_count, to: @interpreter
  delegate input_tensor, input_tensor_count, to: @interpreter

  def unsafe_fetch(index : Int)
    input_tensor(index)
  end

  def size
    input_tensor_count
  end

  def output(index : Int = 0)
    output_tensor(index)
  end

  def outputs
    (0...output_tensor_count).map { |index| output_tensor(index) }
  end
end

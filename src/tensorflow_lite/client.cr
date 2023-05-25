require "uri"
require "../tensorflow_lite"

# provides a simplified way to load and manipulate the tensorflow interpreter
#
# the indexable module provides simplified access to the input tensors
class TensorflowLite::Client
  include Indexable(Tensor)

  # Configures the tensorflow interpreter with the options provided
  def initialize(model : URI | Bytes | Path | Model | String, delegate : Delegate? = nil, threads : Int? = nil, labels : URI | Hash(Int32, String)? = nil, &on_error : String -> Nil)
    @labels_fetched = !!@labels
    @model = case model
             in String, Path
               path = Path.new(model)
               @model_path = path
               Model.new(path)
             in Bytes
               @model_bytes = model
               Model.new(model)
             in Model
               model
             in URI
               HTTP::Client.get(model) do |response|
                 raise "model download failed with #{response.status} (#{response.status_code}) while fetching #{model}" unless response.success?
                 @model_bytes = model_bytes = response.body_io.getb_to_end
                 Model.new model_bytes
               end
             end

    @labels = case labels
              in URI
                response = HTTP::Client.get(labels)
                raise "labels download failed with #{response.status} (#{response.status_code}) while fetching #{labels}" unless response.success?

                labels_keys = {} of Int32 => String
                idx = 0
                response.body.each_line do |line|
                  labels_keys[idx] = line
                  idx += 1
                end
                labels_keys
              in Hash(Int32, String)?
                labels
              end

    @options = InterpreterOptions.new
    @options.on_error(&on_error)
    if threads
      @options.num_threads(threads)
    end
    if delegate
      @options.add_delegate delegate
    end
    @interpreter = Interpreter.new(@model, @options)
  end

  # :ditto:
  def self.new(model : Bytes | Path | Model | String, delegate : Delegate? = nil, threads : Int? = nil)
    Client.new(model, delegate, threads) { |error_message| Log.warn { error_message } }
  end

  getter model : Model
  getter model_path : Path? = nil
  getter options : InterpreterOptions
  getter interpreter : Interpreter

  # This controls the number of CPU threads that the interpreter will use for its computations.
  delegate num_threads, to: @options

  # provide a callback to receive any error messages
  def on_error(&callback : String -> Nil)
    options.on_error(&callback)
  end

  # input tensor details for manipulation and loading of input data
  delegate input_tensor, input_tensor_count, to: @interpreter

  # run the model, processing the input tensors and updating the output tensors
  delegate invoke, invoke!, to: @interpreter

  # output tensors details, used to obtain the results of an invokation
  delegate output_tensor, output_tensor_count, to: @interpreter

  # :nodoc:
  def unsafe_fetch(index : Int)
    input_tensor(index)
  end

  # the number of input tensors
  def size
    input_tensor_count
  end

  # returns the output tensor at the provided index
  def output(index : Int = 0)
    output_tensor(index)
  end

  # returns an array of output tensors
  def outputs
    (0...output_tensor_count).map { |index| output_tensor(index) }
  end

  getter labels_fetched : Bool
  @labels : Hash(Int32, String)?
  @model_bytes : Bytes? = nil

  # attempt to extract any labels in the model
  def labels
    if (labels = @labels) || @labels_fetched
      labels
    elsif path = @model_path
      @labels_fetched = true
      @labels = Utilities::ExtractLabels.from(path)
    elsif bytes = @model_bytes
      @labels_fetched = true
      @model_bytes = nil
      @labels = Utilities::ExtractLabels.from(bytes)
    end
  end
end

require "log"
require "./tensorflow_lite/lib_tensorflowlite"

module TensorflowLite
  Log = ::Log.for("tensorflow_lite")

  {% begin %}
    VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}
  {% end %}

  def self.version
    String.new(LibTensorflowLite.version)
  end

  def self.schema_version
    LibTensorflowLite.schema_version
  end

  Log.info { "Launching with tensorflow lite v#{TensorflowLite.version}" }

  # https://www.tensorflow.org/lite/examples/object_detection/overview
  # need to do a bunch of pre-processing: https://github.com/tensorflow/examples/tree/master/lite/examples/object_detection/android
  # flattened buffer, possibly quantized
  # example app: https://github.com/mattn/go-tflite
end

require "./tensorflow_lite/model"
require "./tensorflow_lite/interpreter_options"
require "./tensorflow_lite/tensor"
require "./tensorflow_lite/interpreter"
require "./tensorflow_lite/client"

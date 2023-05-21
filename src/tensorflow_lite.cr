require "log"
require "./tensorflow_lite/lib_tensorflowlite"

# TensorFlow Lite is a set of tools provided by Google to run TensorFlow models on mobile, embedded, and IoT devices.
#
# It enables on-device machine learning inference with low latency and a small binary size, which are crucial requirements for these types of devices.
module TensorflowLite
  # :nodoc:
  Log = ::Log.for("tensorflow_lite")

  {% begin %}
    VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}
  {% end %}

  # the version of the tensorflow lite library in use
  def self.version
    String.new(LibTensorflowLite.version)
  end

  def self.schema_version
    LibTensorflowLite.schema_version
  end

  Log.info { "Launching with tensorflow lite v#{TensorflowLite.version}" }
end

require "./tensorflow_lite/model"
require "./tensorflow_lite/interpreter_options"
require "./tensorflow_lite/tensor"
require "./tensorflow_lite/interpreter"
require "./tensorflow_lite/client"
require "./tensorflow_lite/utilities/*"

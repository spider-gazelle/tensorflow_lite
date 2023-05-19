require "box"
require "va_list"
require "./lib_tensorflowlite"
require "./delegate"

# :nodoc:
lib C
  fun vasprintf(strp : LibC::Char**, format : LibC::Char*, ap : LibC::VaList) : LibC::Int
end

# Interpreter options provide a way to configure various aspects of the TensorFlow Lite runtime
class TensorflowLite::InterpreterOptions
  def initialize
    tf_options_ptr = LibTensorflowLite.interpreter_options_create
    raise "failed to create tensorflow options" if tf_options_ptr.null?
    @to_unsafe = tf_options_ptr
  end

  # :nodoc:
  getter to_unsafe : LibTensorflowLite::InterpreterOptions
  @callback_ref : Pointer(Void)? = nil

  # :nodoc:
  def finalize
    LibTensorflowLite.interpreter_options_delete(@to_unsafe)
  end

  # This controls the number of CPU threads that the interpreter will use for its computations.
  # This can be useful for improving performance on devices with multiple CPU cores.
  def num_threads(count : Int)
    LibTensorflowLite.interpreter_options_set_num_threads(self, count.to_i32)
  end

  # define a callback to receive any error messages
  def on_error(&callback : String -> Nil)
    # we need our callback to be available
    callback_ptr = Box.box(callback)
    @callback_ref = callback_ptr
    LibTensorflowLite.interpreter_options_set_error_reporter(self, ->(boxed_callback, raw_message, raw_args) {
      result = C.vasprintf(out msg, raw_message, raw_args)
      if result != -1
        formatted_msg = String.new(msg)
        LibC.free(msg.as(Pointer(Void)))
      else
        # failed to format the string, we'll use the message passed to us as a fallback
        formatted_msg = String.new(raw_message)
      end
      unboxed_callback = Box(typeof(callback)).unbox(boxed_callback)
      unboxed_callback.call(formatted_msg)
      nil
    }, callback_ptr)
  end

  # ensure the delegate isn't GC'd
  @delegates : Array(Delegate) = [] of Delegate

  # Delegates are mechanisms that allow the interpreter to offload some or all of the model execution to hardware accelerators, like the GPU, DSP, or specialized Neural Processing Units (NPUs).
  def add_delegate(delegate : Delegate)
    @delegates << delegate
    LibTensorflowLite.interpreter_options_add_delegate(self, delegate)
    self
  end
end

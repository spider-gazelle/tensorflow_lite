require "box"
require "va_list"
require "./lib_tensorflowlite"

lib C
  fun vasprintf(strp : LibC::Char**, format : LibC::Char*, ap : Void*) : LibC::Int
end

class TensorflowLite::InterpreterOptions
  def initialize
    tf_options_ptr = LibTensorflowLite.interpreter_options_create
    raise "failed to create tensorflow options" if tf_options_ptr.null?
    @tf_options_ptr = tf_options_ptr
  end

  getter tf_options_ptr : LibTensorflowLite::InterpreterOptions
  @callback_ref : Pointer(Void)? = nil

  def finalize
    LibTensorflowLite.interpreter_options_delete(@tf_options_ptr)
  end

  def num_threads(count : Int)
    LibTensorflowLite.interpreter_options_set_num_threads(tf_options_ptr, count.to_i32)
  end

  def on_error(&callback : String -> Nil)
    # we need our callback to be available
    callback_ptr = Box.box(callback)
    @callback_ref = callback_ptr
    LibTensorflowLite.interpreter_options_set_error_reporter(tf_options_ptr, ->(boxed_callback, raw_message, raw_args) {
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
end

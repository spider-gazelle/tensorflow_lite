require "box"
require "va_list"
require "./lib_tensorflowlite"

class TensorflowLite::InterpreterOptions
  def initialize
    tf_options_ptr = LibTensorflowLite.interpreter_options_create
    raise "failed to create tensorflow options" if tf_options_ptr.null?
    @tf_options_ptr = tf_options_ptr
  end

  getter tf_options_ptr : LibTensorflowLite::InterpreterOptions
  @callback_ref : Array(Pointer(Void)) = [] of Pointer(Void)

  def finalize
    LibTensorflowLite.interpreter_options_delete(@tf_options_ptr)
  end

  def set_thread_count(count : Int)
    LibTensorflowLite.interpreter_options_set_num_threads(tf_options_ptr, count.to_i32)
  end

  def set_error_reporter(&callback : String -> Nil)
    # we need our callback to be available
    callback_ptr = Box.box(callback)
    @callback_ref << callback_ptr
    LibTensorflowLite.interpreter_options_set_error_reporter(tf_options_ptr, ->(boxed_callback, raw_message, raw_args) {
      va_list = VaList.new(raw_args)
      unboxed_callback = Box(typeof(callback)).unbox(boxed_callback)
      unboxed_callback.call(String.new(raw_message))
      nil
    }, callback_ptr)
  end
end

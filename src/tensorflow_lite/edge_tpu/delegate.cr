require "../delegate"

# a delegate that can be used with InterpreterOptions#add_delegate
class TensorflowLite::EdgeTPU::Delegate < TensorflowLite::Delegate
  def initialize(type : EdgeTPU::Device::Type, path : String)
    options_ptr = Pointer(LibEdgeTPU::Option).null
    delegate_ptr = LibEdgeTPU.create_delegate(type, path, options_ptr, 0)
    @to_unsafe = delegate_ptr

    @path = path
    @type = type
  end

  @path : String
  @type : EdgeTPU::Device::Type

  # :nodoc:
  def finalize
    LibEdgeTPU.free_delegate(@to_unsafe)
  end

  # :nodoc:
  getter to_unsafe : Pointer(LibTensorflowLite::OpaqueDelegate)
end

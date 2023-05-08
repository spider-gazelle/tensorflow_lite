require "../delegate"

class TensorflowLite::EdgeTPU::Delegate < TensorflowLite::Delegate
  def initialize(type, path : String)
    options_ptr = Pointer(LibEdgeTPU::Option).null
    delegate_ptr = LibEdgeTPU.create_delegate(type, path, options_ptr, 0)
    @to_unsafe = delegate_ptr
  end

  def finalize
    LibEdgeTPU.free_delegate(@to_unsafe)
  end

  getter to_unsafe : Pointer(LibTensorflowLite::OpaqueDelegate)
end

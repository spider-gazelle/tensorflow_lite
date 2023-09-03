require "./delegate"

class TensorflowLite::DelegateGPU < TensorflowLite::Delegate
  def initialize
    @options = opts = LibTensorflowLite.gpu_delegate_options_v2_default
    options_ptr = pointerof(opts)
    @delegate = LibTensorflowLite.gpu_delegate_v2_create(options_ptr)
    @to_unsafe = pointerof(@delegate)
  end

  @options : LibTensorflowLite::GpuDelegateOptionsV2
  @delegate : LibTensorflowLite::Delegate

  # :nodoc:
  def finalize
    LibTensorflowLite.gpu_delegate_v2_delete(@delegate)
  end

  # :nodoc:
  getter to_unsafe : Pointer(LibTensorflowLite::Delegate)
end

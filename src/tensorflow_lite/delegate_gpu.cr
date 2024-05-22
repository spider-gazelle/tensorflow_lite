require "./delegate"
require "./delegate_gpu/*"

class TensorflowLite::DelegateGPU < TensorflowLite::Delegate
  def initialize
    @options = opts = LibDelegateGPU.gpu_delegate_options_v2_default
    options_ptr = pointerof(opts)
    @delegate = LibDelegateGPU.gpu_delegate_v2_create(options_ptr)
    @to_unsafe = pointerof(@delegate)
  end

  @options : LibDelegateGPU::GpuDelegateOptionsV2
  @delegate : LibTensorflowLite::OpaqueDelegate

  # :nodoc:
  def finalize
    LibDelegateGPU.gpu_delegate_v2_delete(@delegate)
  end

  # :nodoc:
  getter to_unsafe : Pointer(LibTensorflowLite::OpaqueDelegate)
end

require "./delegate"
require "./gpu_delegate/*"

class TensorflowLite::GpuDelegate < TensorflowLite::Delegate
  def initialize
    @options = opts = LibTensorflowLiteGPU.gpu_delegate_options_v2_default
    options_ptr = pointerof(opts)
    @delegate = LibTensorflowLiteGPU.gpu_delegate_v2_create(options_ptr)
    @to_unsafe = pointerof(@delegate)
  end

  @options : LibTensorflowLiteGPU::GpuDelegateOptionsV2
  @delegate : LibTensorflowLite::Delegate

  # :nodoc:
  def finalize
    LibTensorflowLiteGPU.gpu_delegate_v2_delete(@delegate)
  end

  # :nodoc:
  getter to_unsafe : Pointer(LibTensorflowLite::Delegate)
end

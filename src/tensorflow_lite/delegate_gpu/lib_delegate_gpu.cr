# :nodoc:
@[Link("tensorflowlite_gpu_delegate", ldflags: "-L#{__DIR__}/../../ext/ -Wl,-rpath='$ORIGIN'")]
lib LibDelegateGPU
  alias X__Int32T = LibC::Int
  alias Int32T = X__Int32T

  alias X__Int64T = LibC::Long
  alias Int64T = X__Int64T

  fun gpu_delegate_options_v2_default = TfLiteGpuDelegateOptionsV2Default : GpuDelegateOptionsV2

  struct GpuDelegateOptionsV2
    is_precision_loss_allowed : Int32T
    inference_preference : Int32T
    inference_priority1 : Int32T
    inference_priority2 : Int32T
    inference_priority3 : Int32T
    experimental_flags : Int64T
    max_delegated_partitions : Int32T
    serialization_dir : LibC::Char*
    model_token : LibC::Char*
  end

  fun gpu_delegate_v2_create = TfLiteGpuDelegateV2Create(options : GpuDelegateOptionsV2*) : LibTensorflowLite::OpaqueDelegate
  fun gpu_delegate_v2_delete = TfLiteGpuDelegateV2Delete(delegate : LibTensorflowLite::OpaqueDelegate)
end

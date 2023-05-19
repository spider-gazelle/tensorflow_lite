require "../lib_tensorflowlite"

# :nodoc:
@[Link("edgetpu")]
lib LibEdgeTPU
  struct Device
    type : DeviceType
    path : LibC::Char*
  end

  enum DeviceType
    EdgetpuApexPci = 0
    EdgetpuApexUsb = 1
  end

  struct Option
    name : LibC::Char*
    value : LibC::Char*
  end

  fun list_devices = edgetpu_list_devices(num_devices : LibC::SizeT*) : Device*
  fun free_devices = edgetpu_free_devices(dev : Device*)
  fun create_delegate = edgetpu_create_delegate(type : DeviceType, name : LibC::Char*, options : Option*, num_options : LibC::SizeT) : LibTensorflowLite::OpaqueDelegate*
  fun free_delegate = edgetpu_free_delegate(delegate : LibTensorflowLite::OpaqueDelegate*)
  fun verbosity = edgetpu_verbosity(verbosity : LibC::Int)
  fun version = edgetpu_version : LibC::Char*
end

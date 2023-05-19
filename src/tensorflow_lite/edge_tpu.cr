require "../tensorflow_lite"
require "./edge_tpu/lib_edge_tpu"

# An Edge TPU (Tensor Processing Unit) is a small ASIC (Application-Specific Integrated Circuit) designed for accelerating machine learning workloads at the edge, that is, on devices like smartphones, IoT devices, and embedded systems.
#
# Google's Coral product line includes various devices that incorporate the Edge TPU, such as the Coral Dev Board, the Coral USB Accelerator, and various system-on-modules (SoMs) and PCI-E cards.
module TensorflowLite::EdgeTPU
  # the version of the edge tpu library in use
  def self.version : String
    String.new(LibEdgeTPU.version)
  end

  # :nodoc:
  class_getter device_obj : Devices { Devices.new }

  # the list of Edge TPU devices available on the system
  class_getter devices : Array(Device) { device_obj.list }
end

require "./edge_tpu/devices"
require "./edge_tpu/delegate"

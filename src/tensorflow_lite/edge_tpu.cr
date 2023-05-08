require "../tensorflow_lite"
require "./edge_tpu/lib_edge_tpu"

module TensorflowLite::EdgeTPU
  def self.version : String
    String.new(LibEdgeTPU.version)
  end

  class_getter device_obj : Devices { Devices.new }
  class_getter devices : Array(Device) { device_obj.list }
end

require "./edge_tpu/devices"
require "./edge_tpu/delegate"

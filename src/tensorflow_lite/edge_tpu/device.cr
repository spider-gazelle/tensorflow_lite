require "../edge_tpu"

struct TensorflowLite::EdgeTPU::Device
  def initialize(device : LibEdgeTPU::Device)
    @to_unsafe = device
    @type = device.type
    @path = String.new(device.path)
  end

  alias Type = LibEdgeTPU::DeviceType

  getter type : Type
  getter path : String
  getter to_unsafe : LibEdgeTPU::Device

  def to_delegate
    EdgeTPU::Delegate.new(@type, @path)
  end
end

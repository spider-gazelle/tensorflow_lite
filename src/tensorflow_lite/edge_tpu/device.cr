require "../edge_tpu"

# the file path to and type of Edge TPU device
struct TensorflowLite::EdgeTPU::Device
  def initialize(device : LibEdgeTPU::Device)
    @to_unsafe = device
    @type = device.type
    @path = String.new(device.path)
  end

  alias Type = LibEdgeTPU::DeviceType

  # the type of device at the path listed
  getter type : Type

  # the path to the device
  getter path : String

  # :nodoc:
  getter to_unsafe : LibEdgeTPU::Device

  # creates a delegate object that can be added to with InterpreterOptions#add_delegate
  def to_delegate
    EdgeTPU::Delegate.new(@type, @path)
  end
end

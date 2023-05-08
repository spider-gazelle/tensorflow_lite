require "../edge_tpu"
require "./device"

class TensorflowLite::EdgeTPU::Devices
  def initialize
    num_devices = LibC::SizeT.new(0)
    num_devices_ptr = pointerof(num_devices)

    dev_ptr = LibEdgeTPU.list_devices(num_devices_ptr)
    raise "failed to obtain device list" if dev_ptr.null? && num_devices > 0
    @size = num_devices.to_i

    if num_devices == 0
      @devices_ptr = nil
    else
      @devices_ptr = dev_ptr
    end
  end

  @devices_ptr : Pointer(LibEdgeTPU::Device)?
  getter size : Int32

  def finalize
    if dev_ptr = @devices_ptr
      LibEdgeTPU.free_devices(dev_ptr)
    end
  end

  def list : Array(Device)
    if dev_ptr = @devices_ptr
      (0...@size).map { |index| Device.new(dev_ptr[index]) }
    else
      [] of Device
    end
  end
end

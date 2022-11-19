require "./lib_tensorflowlite"

struct TensorflowLite::Tensor
  def initialize(tf_tensor_ptr : LibTensorflowLite::Tensor)
    raise "not a valid tensor pointer" if tf_tensor_ptr.null?
    @tf_tensor_ptr = tf_tensor_ptr
  end

  getter tf_tensor_ptr : LibTensorflowLite::Tensor
  getter name : String { String.new LibTensorflowLite.tensor_name(@tf_tensor_ptr) }

  getter bytesize : Int32 do
    LibTensorflowLite.tensor_byte_size(@tf_tensor_ptr).to_i
  end

  getter dimensions : Int32 do
    LibTensorflowLite.tensor_num_dims(@tf_tensor_ptr).to_i
  end

  def dimension_size(index : Int) : Int32
    raise IndexError.new if index >= dimensions || index < 0
    LibTensorflowLite.tensor_dim(@tf_tensor_ptr, index.to_i32).to_i
  end

  def raw_data : Bytes
    data_ptr = LibTensorflowLite.tensor_data(@tf_tensor_ptr)
    Slice.new(data_ptr.as(Pointer(UInt8)), bytesize)
  end

  alias Type = LibTensorflowLite::Type

  def type : Type
    LibTensorflowLite.tensor_type(@tf_tensor_ptr)
  end

  macro to_type(klass)
    the_type = type
    raise TypeCastError.new("can't convert #{the_type} to #{ {{klass}} }") unless the_type == Type::{{klass}}
    data_ptr = LibTensorflowLite.tensor_data(@tf_tensor_ptr)
    count = bytesize // sizeof({{klass}})
    Slice.new(data_ptr.as(Pointer({{klass}})), count)
  end

  def as_f32
    to_type(Float32)
  end

  def as_i32
    to_type(Int32)
  end

  def as_i
    as_i32
  end

  def as_u8
    to_type(UInt8)
  end

  def as_i64
    to_type(Int64)
  end

  def as_i16
    to_type(Int16)
  end

  def as_i8
    to_type(Int8)
  end

  def as_f64
    to_type(Int8)
  end

  def as_f
    as_f64
  end

  def as_u64
    to_type(UInt64)
  end

  def as_u32
    to_type(UInt32)
  end

  def as_u16
    to_type(UInt16)
  end
end

require "./lib_tensorflowlite"

struct TensorflowLite::Tensor
  include Indexable(Int32)

  def initialize(tf_tensor_ptr : LibTensorflowLite::Tensor)
    raise "not a valid tensor pointer" if tf_tensor_ptr.null?
    @tf_tensor_ptr = tf_tensor_ptr
  end

  getter tf_tensor_ptr : LibTensorflowLite::Tensor

  alias Type = LibTensorflowLite::Type

  # The datatype this tensor expects as input
  getter type : Type do
    LibTensorflowLite.tensor_type(@tf_tensor_ptr)
  end

  # The friendly name of the tensor
  getter name : String { String.new LibTensorflowLite.tensor_name(@tf_tensor_ptr) }

  # the size of the buffer backing this tensor
  getter bytesize : Int32 do
    LibTensorflowLite.tensor_byte_size(@tf_tensor_ptr).to_i
  end

  # Returns the number of dimensions (sometimes referred to as rank) of the Tensor.
  # Will be 0 for a scalar, 1 for a vector, 2 for a matrix, 3 for a 3-dimensional tensor etc.
  getter dimensions : Int32 do
    LibTensorflowLite.tensor_num_dims(@tf_tensor_ptr).to_i
  end

  # :ditto:
  def rank
    dimensions
  end

  def dimension_size(index : Int) : Int32
    raise IndexError.new if index >= dimensions || index < 0
    LibTensorflowLite.tensor_dim(@tf_tensor_ptr, index.to_i32).to_i
  end

  # dimensions are indexed
  def unsafe_fetch(index : Int)
    dimension_size(index)
  end

  def size
    dimensions
  end

  # buffer that makes up the tensor input
  def raw_data : Bytes
    data_ptr = LibTensorflowLite.tensor_data(@tf_tensor_ptr)
    Slice.new(data_ptr.as(Pointer(UInt8)), bytesize)
  end

  # :ditto:
  def to_slice
    raw_data
  end

  # attempts to calculate the number on inputs/outputs based on the type
  def io_count
    klass_size = case type
                 when .float32?
                   sizeof(Float32)
                 when .float64?
                   sizeof(Float64)
                 when .u_int8?
                   sizeof(UInt8)
                 when .int8?
                   sizeof(Int8)
                 when .u_int16?
                   sizeof(UInt16)
                 when .int16?
                   sizeof(Int16)
                 when .u_int32?
                   sizeof(UInt32)
                 when .int32?
                   sizeof(Int32)
                 when .u_int64?
                   sizeof(UInt64)
                 when .int64?
                   sizeof(Int64)
                 else
                   # fallback to using dimensions
                   return self.reduce { |acc, i| acc * i }
                 end
    bytesize // klass_size
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

  def as_f64
    to_type(Int8)
  end

  def as_f
    as_f64
  end

  def as_u8
    to_type(UInt8)
  end

  def as_i8
    to_type(Int8)
  end

  def as_u16
    to_type(UInt16)
  end

  def as_i16
    to_type(Int16)
  end

  def as_u32
    to_type(UInt32)
  end

  def as_i32
    to_type(Int32)
  end

  def as_i
    as_i32
  end

  def as_u64
    to_type(UInt64)
  end

  def as_i64
    to_type(Int64)
  end
end

require "./lib_tensorflowlite"

# A tensor is a multi-dimensional array used as the basic data structure.
# This array can have any number of dimensions, and is used to represent data of various types, such as numeric, boolean, or string values.
#
# The dimensions of a tensor are often referred to as "ranks". For instance:
#
# * A rank 0 tensor is a scalar (a single number).
# * A rank 1 tensor is a vector (a 1D array).
# * A rank 2 tensor is a matrix (a 2D array).
# * A rank 3 tensor is a 3D array, and so on for higher dimensions.
#
# Each tensor in TensorFlow is also associated with a data type (such as float32, int32, or string) and a shape.
# The shape of a tensor is the number of elements in each dimension.
#
# For example, a 3x3 matrix has a shape of [3, 3].
struct TensorflowLite::Tensor
  include Indexable(Int32)

  def initialize(tf_tensor_ptr : LibTensorflowLite::Tensor)
    raise "not a valid tensor pointer" if tf_tensor_ptr.null?
    @to_unsafe = tf_tensor_ptr
  end

  # :nodoc:
  getter to_unsafe : LibTensorflowLite::Tensor

  # the type of tensor, i.e. Float32 or Int8 etc
  alias Type = LibTensorflowLite::Type

  # The datatype this tensor holds
  #
  # the type of data it expects as input or provides as output
  getter type : Type do
    LibTensorflowLite.tensor_type(self)
  end

  # The friendly name of the tensor
  getter name : String { String.new LibTensorflowLite.tensor_name(self) }

  # the size of the buffer backing this tensor
  getter bytesize : Int32 do
    LibTensorflowLite.tensor_byte_size(self).to_i
  end

  # Returns the number of dimensions (sometimes referred to as rank) of the Tensor.
  # Will be 0 for a scalar, 1 for a vector, 2 for a matrix, 3 for a 3-dimensional tensor etc.
  getter dimensions : Int32 do
    LibTensorflowLite.tensor_num_dims(self).to_i
  end

  # :ditto:
  def rank
    dimensions
  end

  # :ditto:
  def size
    dimensions
  end

  # returns the number elements in this dimension or rank index
  def dimension_size(index : Int) : Int32
    raise IndexError.new if index >= dimensions || index < 0
    unsafe_fetch index
  end

  # :nodoc:
  def unsafe_fetch(index : Int)
    LibTensorflowLite.tensor_dim(self, index.to_i32).to_i
  end

  # buffer that makes up the tensor input
  def raw_data : Bytes
    data_ptr = LibTensorflowLite.tensor_data(self)
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

  # type casts the tensor buffer into the appropriate crystal lang type.
  #
  # returns a Slice of the provided klass against the buffer for manipulation
  macro to_type(klass)
    the_type = type
    raise TypeCastError.new("can't convert #{the_type} to #{ {{klass}} }") unless the_type == Type::{{klass}}
    data_ptr = LibTensorflowLite.tensor_data(self)
    count = bytesize // sizeof({{klass}})
    Slice.new(data_ptr.as(Pointer({{klass}})), count)
  end

  # provides a view into the tensor buffer as the requested type
  def as_f32
    to_type(Float32)
  end

  # :ditto:
  def as_f64
    to_type(Int8)
  end

  # :ditto:
  def as_f
    as_f64
  end

  # :ditto:
  def as_u8
    to_type(UInt8)
  end

  # :ditto:
  def as_i8
    to_type(Int8)
  end

  # :ditto:
  def as_u16
    to_type(UInt16)
  end

  # :ditto:
  def as_i16
    to_type(Int16)
  end

  # :ditto:
  def as_u32
    to_type(UInt32)
  end

  # :ditto:
  def as_i32
    to_type(Int32)
  end

  # :ditto:
  def as_i
    as_i32
  end

  # :ditto:
  def as_u64
    to_type(UInt64)
  end

  # :ditto:
  def as_i64
    to_type(Int64)
  end
end

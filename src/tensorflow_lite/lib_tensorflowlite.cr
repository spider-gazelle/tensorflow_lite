# :nodoc:
@[Link("tensorflowlite_c", ldflags: "-L#{__DIR__}/../../ext/ -Wl,-rpath='$ORIGIN'")]
lib LibTensorflowLite
  BuiltinAdd                          =   0_i64
  BuiltinAveragePool2d                =   1_i64
  BuiltinConcatenation                =   2_i64
  BuiltinConv2d                       =   3_i64
  BuiltinDepthwiseConv2d              =   4_i64
  BuiltinDepthToSpace                 =   5_i64
  BuiltinDequantize                   =   6_i64
  BuiltinEmbeddingLookup              =   7_i64
  BuiltinFloor                        =   8_i64
  BuiltinFullyConnected               =   9_i64
  BuiltinHashtableLookup              =  10_i64
  BuiltinL2Normalization              =  11_i64
  BuiltinL2Pool2d                     =  12_i64
  BuiltinLocalResponseNormalization   =  13_i64
  BuiltinLogistic                     =  14_i64
  BuiltinLshProjection                =  15_i64
  BuiltinLstm                         =  16_i64
  BuiltinMaxPool2d                    =  17_i64
  BuiltinMul                          =  18_i64
  BuiltinRelu                         =  19_i64
  BuiltinReluN1To1                    =  20_i64
  BuiltinRelu6                        =  21_i64
  BuiltinReshape                      =  22_i64
  BuiltinResizeBilinear               =  23_i64
  BuiltinRnn                          =  24_i64
  BuiltinSoftmax                      =  25_i64
  BuiltinSpaceToDepth                 =  26_i64
  BuiltinSvdf                         =  27_i64
  BuiltinTanh                         =  28_i64
  BuiltinConcatEmbeddings             =  29_i64
  BuiltinSkipGram                     =  30_i64
  BuiltinCall                         =  31_i64
  BuiltinCustom                       =  32_i64
  BuiltinEmbeddingLookupSparse        =  33_i64
  BuiltinPad                          =  34_i64
  BuiltinUnidirectionalSequenceRnn    =  35_i64
  BuiltinGather                       =  36_i64
  BuiltinBatchToSpaceNd               =  37_i64
  BuiltinSpaceToBatchNd               =  38_i64
  BuiltinTranspose                    =  39_i64
  BuiltinMean                         =  40_i64
  BuiltinSub                          =  41_i64
  BuiltinDiv                          =  42_i64
  BuiltinSqueeze                      =  43_i64
  BuiltinUnidirectionalSequenceLstm   =  44_i64
  BuiltinStridedSlice                 =  45_i64
  BuiltinBidirectionalSequenceRnn     =  46_i64
  BuiltinExp                          =  47_i64
  BuiltinTopkV2                       =  48_i64
  BuiltinSplit                        =  49_i64
  BuiltinLogSoftmax                   =  50_i64
  BuiltinDelegate                     =  51_i64
  BuiltinBidirectionalSequenceLstm    =  52_i64
  BuiltinCast                         =  53_i64
  BuiltinPrelu                        =  54_i64
  BuiltinMaximum                      =  55_i64
  BuiltinArgMax                       =  56_i64
  BuiltinMinimum                      =  57_i64
  BuiltinLess                         =  58_i64
  BuiltinNeg                          =  59_i64
  BuiltinPadv2                        =  60_i64
  BuiltinGreater                      =  61_i64
  BuiltinGreaterEqual                 =  62_i64
  BuiltinLessEqual                    =  63_i64
  BuiltinSelect                       =  64_i64
  BuiltinSlice                        =  65_i64
  BuiltinSin                          =  66_i64
  BuiltinTransposeConv                =  67_i64
  BuiltinSparseToDense                =  68_i64
  BuiltinTile                         =  69_i64
  BuiltinExpandDims                   =  70_i64
  BuiltinEqual                        =  71_i64
  BuiltinNotEqual                     =  72_i64
  BuiltinLog                          =  73_i64
  BuiltinSum                          =  74_i64
  BuiltinSqrt                         =  75_i64
  BuiltinRsqrt                        =  76_i64
  BuiltinShape                        =  77_i64
  BuiltinPow                          =  78_i64
  BuiltinArgMin                       =  79_i64
  BuiltinFakeQuant                    =  80_i64
  BuiltinReduceProd                   =  81_i64
  BuiltinReduceMax                    =  82_i64
  BuiltinPack                         =  83_i64
  BuiltinLogicalOr                    =  84_i64
  BuiltinOneHot                       =  85_i64
  BuiltinLogicalAnd                   =  86_i64
  BuiltinLogicalNot                   =  87_i64
  BuiltinUnpack                       =  88_i64
  BuiltinReduceMin                    =  89_i64
  BuiltinFloorDiv                     =  90_i64
  BuiltinReduceAny                    =  91_i64
  BuiltinSquare                       =  92_i64
  BuiltinZerosLike                    =  93_i64
  BuiltinFill                         =  94_i64
  BuiltinFloorMod                     =  95_i64
  BuiltinRange                        =  96_i64
  BuiltinResizeNearestNeighbor        =  97_i64
  BuiltinLeakyRelu                    =  98_i64
  BuiltinSquaredDifference            =  99_i64
  BuiltinMirrorPad                    = 100_i64
  BuiltinAbs                          = 101_i64
  BuiltinSplitV                       = 102_i64
  BuiltinUnique                       = 103_i64
  BuiltinCeil                         = 104_i64
  BuiltinReverseV2                    = 105_i64
  BuiltinAddN                         = 106_i64
  BuiltinGatherNd                     = 107_i64
  BuiltinCos                          = 108_i64
  BuiltinWhere                        = 109_i64
  BuiltinRank                         = 110_i64
  BuiltinElu                          = 111_i64
  BuiltinReverseSequence              = 112_i64
  BuiltinMatrixDiag                   = 113_i64
  BuiltinQuantize                     = 114_i64
  BuiltinMatrixSetDiag                = 115_i64
  BuiltinRound                        = 116_i64
  BuiltinHardSwish                    = 117_i64
  BuiltinIf                           = 118_i64
  BuiltinWhile                        = 119_i64
  BuiltinNonMaxSuppressionV4          = 120_i64
  BuiltinNonMaxSuppressionV5          = 121_i64
  BuiltinScatterNd                    = 122_i64
  BuiltinSelectV2                     = 123_i64
  BuiltinDensify                      = 124_i64
  BuiltinSegmentSum                   = 125_i64
  BuiltinBatchMatmul                  = 126_i64
  BuiltinPlaceholderForGreaterOpCodes = 127_i64
  BuiltinCumsum                       = 128_i64
  BuiltinCallOnce                     = 129_i64
  BuiltinBroadcastTo                  = 130_i64
  BuiltinRfft2d                       = 131_i64
  BuiltinConv3d                       = 132_i64
  BuiltinImag                         = 133_i64
  BuiltinReal                         = 134_i64
  BuiltinComplexAbs                   = 135_i64
  BuiltinHashtable                    = 136_i64
  BuiltinHashtableFind                = 137_i64
  BuiltinHashtableImport              = 138_i64
  BuiltinHashtableSize                = 139_i64
  BuiltinReduceAll                    = 140_i64
  BuiltinConv3dTranspose              = 141_i64
  BuiltinVarHandle                    = 142_i64
  BuiltinReadVariable                 = 143_i64
  BuiltinAssignVariable               = 144_i64
  BuiltinBroadcastArgs                = 145_i64
  BuiltinRandomStandardNormal         = 146_i64
  BuiltinBucketize                    = 147_i64
  BuiltinRandomUniform                = 148_i64
  BuiltinMultinomial                  = 149_i64
  BuiltinGelu                         = 150_i64
  BuiltinDynamicUpdateSlice           = 151_i64
  BuiltinRelu0To1                     = 152_i64
  BuiltinUnsortedSegmentProd          = 153_i64
  BuiltinUnsortedSegmentMax           = 154_i64
  BuiltinUnsortedSegmentSum           = 155_i64
  BuiltinAtan2                        = 156_i64
  BuiltinUnsortedSegmentMin           = 157_i64
  BuiltinSign                         = 158_i64
  BuiltinBitcast                      = 159_i64
  BuiltinBitwiseXor                   = 160_i64
  BuiltinRightShift                   = 161_i64
  BuiltinStablehloLogistic            = 162_i64
  BuiltinStablehloAdd                 = 163_i64
  BuiltinStablehloDivide              = 164_i64
  BuiltinStablehloMultiply            = 165_i64
  BuiltinStablehloMaximum             = 166_i64
  BuiltinStablehloReshape             = 167_i64
  BuiltinStablehloClamp               = 168_i64
  BuiltinStablehloConcatenate         = 169_i64
  BuiltinStablehloBroadcastInDim      = 170_i64
  BuiltinStablehloConvolution         = 171_i64
  BuiltinStablehloSlice               = 172_i64
  BuiltinStablehloCustomCall          = 173_i64
  BuiltinStablehloReduce              = 174_i64
  BuiltinStablehloAbs                 = 175_i64
  BuiltinStablehloAnd                 = 176_i64
  BuiltinStablehloCosine              = 177_i64
  BuiltinStablehloExponential         = 178_i64
  BuiltinStablehloFloor               = 179_i64
  BuiltinStablehloLog                 = 180_i64
  BuiltinStablehloMinimum             = 181_i64
  BuiltinStablehloNegate              = 182_i64
  BuiltinStablehloOr                  = 183_i64
  BuiltinStablehloPower               = 184_i64
  BuiltinStablehloRemainder           = 185_i64
  BuiltinStablehloRsqrt               = 186_i64
  BuiltinStablehloSelect              = 187_i64
  BuiltinStablehloSubtract            = 188_i64
  BuiltinStablehloTanh                = 189_i64
  BuiltinStablehloScatter             = 190_i64
  BuiltinStablehloCompare             = 191_i64
  BuiltinStablehloConvert             = 192_i64
  BuiltinStablehloDynamicSlice        = 193_i64
  BuiltinStablehloDynamicUpdateSlice  = 194_i64
  BuiltinStablehloPad                 = 195_i64
  BuiltinStablehloIota                = 196_i64
  BuiltinStablehloDotGeneral          = 197_i64
  BuiltinStablehloReduceWindow        = 198_i64
  BuiltinStablehloSort                = 199_i64
  BuiltinStablehloWhile               = 200_i64
  BuiltinStablehloGather              = 201_i64
  BuiltinStablehloTranspose           = 202_i64
  NoType                              =   0_i64
  Float32                             =   1_i64
  Int32                               =   2_i64
  UInt8                               =   3_i64
  Int64                               =   4_i64
  String                              =   5_i64
  Bool                                =   6_i64
  Int16                               =   7_i64
  Complex64                           =   8_i64
  Int8                                =   9_i64
  Float16                             =  10_i64
  Float64                             =  11_i64
  Complex128                          =  12_i64
  UInt64                              =  13_i64
  Resource                            =  14_i64
  Variant                             =  15_i64
  UInt32                              =  16_i64
  UInt16                              =  17_i64
  Int4                                =  18_i64

  struct QuantizationParams
    scale : LibC::Float
    zero_point : Int32T
  end

  alias X__Int32T = LibC::Int
  alias Int32T = X__Int32T
  fun version = TfLiteVersion : LibC::Char*
  fun schema_version = TfLiteSchemaVersion : LibC::Int
  fun model_create = TfLiteModelCreate(model_data : Void*, model_size : LibC::SizeT) : Model
  type Model = Void*
  fun model_create_with_error_reporter = TfLiteModelCreateWithErrorReporter(model_data : Void*, model_size : LibC::SizeT, reporter : (Void*, LibC::Char*, VaList -> Void), user_data : Void*) : Model
  alias X__GnucVaList = LibC::VaList
  alias VaList = X__GnucVaList
  fun model_create_from_file = TfLiteModelCreateFromFile(model_path : LibC::Char*) : Model
  fun model_create_from_file_with_error_reporter = TfLiteModelCreateFromFileWithErrorReporter(model_path : LibC::Char*, reporter : (Void*, LibC::Char*, VaList -> Void), user_data : Void*) : Model
  fun model_delete = TfLiteModelDelete(model : Model)
  fun interpreter_options_create = TfLiteInterpreterOptionsCreate : InterpreterOptions
  type InterpreterOptions = Void*
  fun interpreter_options_copy = TfLiteInterpreterOptionsCopy(from : InterpreterOptions) : InterpreterOptions
  fun interpreter_options_delete = TfLiteInterpreterOptionsDelete(options : InterpreterOptions)
  fun interpreter_options_set_num_threads = TfLiteInterpreterOptionsSetNumThreads(options : InterpreterOptions, num_threads : Int32T)
  fun interpreter_options_add_delegate = TfLiteInterpreterOptionsAddDelegate(options : InterpreterOptions, delegate : OpaqueDelegate*)
  alias OpaqueDelegate = Delegate
  fun interpreter_options_set_error_reporter = TfLiteInterpreterOptionsSetErrorReporter(options : InterpreterOptions, reporter : (Void*, LibC::Char*, VaList -> Void), user_data : Void*)
  fun interpreter_options_add_registration_external = TfLiteInterpreterOptionsAddRegistrationExternal(options : InterpreterOptions, registration : LibC::Int*)
  fun interpreter_options_enable_cancellation = TfLiteInterpreterOptionsEnableCancellation(options : InterpreterOptions, enable : LibC::Int) : Status
  enum Status
    Ok                     = 0
    Error                  = 1
    DelegateError          = 2
    ApplicationError       = 3
    DelegateDataNotFound   = 4
    DelegateDataWriteError = 5
    DelegateDataReadError  = 6
    UnresolvedOps          = 7
    Cancelled              = 8
  end
  fun interpreter_create = TfLiteInterpreterCreate(model : Model, optional_options : InterpreterOptions) : Interpreter
  type Interpreter = Void*
  fun interpreter_delete = TfLiteInterpreterDelete(interpreter : Interpreter)
  fun interpreter_get_input_tensor_count = TfLiteInterpreterGetInputTensorCount(interpreter : Interpreter) : Int32T
  fun interpreter_input_tensor_indices = TfLiteInterpreterInputTensorIndices(interpreter : Interpreter) : LibC::Int*
  fun interpreter_get_input_tensor = TfLiteInterpreterGetInputTensor(interpreter : Interpreter, input_index : Int32T) : Tensor
  type Tensor = Void*
  fun interpreter_resize_input_tensor = TfLiteInterpreterResizeInputTensor(interpreter : Interpreter, input_index : Int32T, input_dims : LibC::Int*, input_dims_size : Int32T) : Status
  fun interpreter_allocate_tensors = TfLiteInterpreterAllocateTensors(interpreter : Interpreter) : Status
  fun interpreter_invoke = TfLiteInterpreterInvoke(interpreter : Interpreter) : Status
  fun interpreter_get_output_tensor_count = TfLiteInterpreterGetOutputTensorCount(interpreter : Interpreter) : Int32T
  fun interpreter_output_tensor_indices = TfLiteInterpreterOutputTensorIndices(interpreter : Interpreter) : LibC::Int*
  fun interpreter_get_output_tensor = TfLiteInterpreterGetOutputTensor(interpreter : Interpreter, output_index : Int32T) : Tensor
  fun interpreter_get_tensor = TfLiteInterpreterGetTensor(interpreter : Interpreter, index : LibC::Int) : Tensor
  fun interpreter_cancel = TfLiteInterpreterCancel(interpreter : Interpreter) : Status
  fun tensor_type = TfLiteTensorType(tensor : Tensor) : Type
  enum Type
    NoType     =  0
    Float32    =  1
    Int32      =  2
    UInt8      =  3
    Int64      =  4
    String     =  5
    Bool       =  6
    Int16      =  7
    Complex64  =  8
    Int8       =  9
    Float16    = 10
    Float64    = 11
    Complex128 = 12
    UInt64     = 13
    Resource   = 14
    Variant    = 15
    UInt32     = 16
    UInt16     = 17
    Int4       = 18
  end
  fun tensor_num_dims = TfLiteTensorNumDims(tensor : Tensor) : Int32T
  fun tensor_dim = TfLiteTensorDim(tensor : Tensor, dim_index : Int32T) : Int32T
  fun tensor_byte_size = TfLiteTensorByteSize(tensor : Tensor) : LibC::SizeT
  fun tensor_data = TfLiteTensorData(tensor : Tensor) : Void*
  fun tensor_name = TfLiteTensorName(tensor : Tensor) : LibC::Char*
  fun tensor_quantization_params = TfLiteTensorQuantizationParams(tensor : Tensor) : QuantizationParams
  fun tensor_copy_from_buffer = TfLiteTensorCopyFromBuffer(tensor : Tensor, input_data : Void*, input_data_size : LibC::SizeT) : Status
  fun tensor_copy_to_buffer = TfLiteTensorCopyToBuffer(output_tensor : Tensor, output_data : Void*, output_data_size : LibC::SizeT) : Status
  fun interpreter_reset_variable_tensors = TfLiteInterpreterResetVariableTensors(interpreter : Interpreter) : Status
  fun interpreter_options_add_builtin_op = TfLiteInterpreterOptionsAddBuiltinOp(options : InterpreterOptions, op : BuiltinOperator, registration : LibC::Int*, min_version : Int32T, max_version : Int32T)
  enum BuiltinOperator
    BuiltinAdd                          =   0
    BuiltinAveragePool2d                =   1
    BuiltinConcatenation                =   2
    BuiltinConv2d                       =   3
    BuiltinDepthwiseConv2d              =   4
    BuiltinDepthToSpace                 =   5
    BuiltinDequantize                   =   6
    BuiltinEmbeddingLookup              =   7
    BuiltinFloor                        =   8
    BuiltinFullyConnected               =   9
    BuiltinHashtableLookup              =  10
    BuiltinL2Normalization              =  11
    BuiltinL2Pool2d                     =  12
    BuiltinLocalResponseNormalization   =  13
    BuiltinLogistic                     =  14
    BuiltinLshProjection                =  15
    BuiltinLstm                         =  16
    BuiltinMaxPool2d                    =  17
    BuiltinMul                          =  18
    BuiltinRelu                         =  19
    BuiltinReluN1To1                    =  20
    BuiltinRelu6                        =  21
    BuiltinReshape                      =  22
    BuiltinResizeBilinear               =  23
    BuiltinRnn                          =  24
    BuiltinSoftmax                      =  25
    BuiltinSpaceToDepth                 =  26
    BuiltinSvdf                         =  27
    BuiltinTanh                         =  28
    BuiltinConcatEmbeddings             =  29
    BuiltinSkipGram                     =  30
    BuiltinCall                         =  31
    BuiltinCustom                       =  32
    BuiltinEmbeddingLookupSparse        =  33
    BuiltinPad                          =  34
    BuiltinUnidirectionalSequenceRnn    =  35
    BuiltinGather                       =  36
    BuiltinBatchToSpaceNd               =  37
    BuiltinSpaceToBatchNd               =  38
    BuiltinTranspose                    =  39
    BuiltinMean                         =  40
    BuiltinSub                          =  41
    BuiltinDiv                          =  42
    BuiltinSqueeze                      =  43
    BuiltinUnidirectionalSequenceLstm   =  44
    BuiltinStridedSlice                 =  45
    BuiltinBidirectionalSequenceRnn     =  46
    BuiltinExp                          =  47
    BuiltinTopkV2                       =  48
    BuiltinSplit                        =  49
    BuiltinLogSoftmax                   =  50
    BuiltinDelegate                     =  51
    BuiltinBidirectionalSequenceLstm    =  52
    BuiltinCast                         =  53
    BuiltinPrelu                        =  54
    BuiltinMaximum                      =  55
    BuiltinArgMax                       =  56
    BuiltinMinimum                      =  57
    BuiltinLess                         =  58
    BuiltinNeg                          =  59
    BuiltinPadv2                        =  60
    BuiltinGreater                      =  61
    BuiltinGreaterEqual                 =  62
    BuiltinLessEqual                    =  63
    BuiltinSelect                       =  64
    BuiltinSlice                        =  65
    BuiltinSin                          =  66
    BuiltinTransposeConv                =  67
    BuiltinSparseToDense                =  68
    BuiltinTile                         =  69
    BuiltinExpandDims                   =  70
    BuiltinEqual                        =  71
    BuiltinNotEqual                     =  72
    BuiltinLog                          =  73
    BuiltinSum                          =  74
    BuiltinSqrt                         =  75
    BuiltinRsqrt                        =  76
    BuiltinShape                        =  77
    BuiltinPow                          =  78
    BuiltinArgMin                       =  79
    BuiltinFakeQuant                    =  80
    BuiltinReduceProd                   =  81
    BuiltinReduceMax                    =  82
    BuiltinPack                         =  83
    BuiltinLogicalOr                    =  84
    BuiltinOneHot                       =  85
    BuiltinLogicalAnd                   =  86
    BuiltinLogicalNot                   =  87
    BuiltinUnpack                       =  88
    BuiltinReduceMin                    =  89
    BuiltinFloorDiv                     =  90
    BuiltinReduceAny                    =  91
    BuiltinSquare                       =  92
    BuiltinZerosLike                    =  93
    BuiltinFill                         =  94
    BuiltinFloorMod                     =  95
    BuiltinRange                        =  96
    BuiltinResizeNearestNeighbor        =  97
    BuiltinLeakyRelu                    =  98
    BuiltinSquaredDifference            =  99
    BuiltinMirrorPad                    = 100
    BuiltinAbs                          = 101
    BuiltinSplitV                       = 102
    BuiltinUnique                       = 103
    BuiltinCeil                         = 104
    BuiltinReverseV2                    = 105
    BuiltinAddN                         = 106
    BuiltinGatherNd                     = 107
    BuiltinCos                          = 108
    BuiltinWhere                        = 109
    BuiltinRank                         = 110
    BuiltinElu                          = 111
    BuiltinReverseSequence              = 112
    BuiltinMatrixDiag                   = 113
    BuiltinQuantize                     = 114
    BuiltinMatrixSetDiag                = 115
    BuiltinRound                        = 116
    BuiltinHardSwish                    = 117
    BuiltinIf                           = 118
    BuiltinWhile                        = 119
    BuiltinNonMaxSuppressionV4          = 120
    BuiltinNonMaxSuppressionV5          = 121
    BuiltinScatterNd                    = 122
    BuiltinSelectV2                     = 123
    BuiltinDensify                      = 124
    BuiltinSegmentSum                   = 125
    BuiltinBatchMatmul                  = 126
    BuiltinPlaceholderForGreaterOpCodes = 127
    BuiltinCumsum                       = 128
    BuiltinCallOnce                     = 129
    BuiltinBroadcastTo                  = 130
    BuiltinRfft2d                       = 131
    BuiltinConv3d                       = 132
    BuiltinImag                         = 133
    BuiltinReal                         = 134
    BuiltinComplexAbs                   = 135
    BuiltinHashtable                    = 136
    BuiltinHashtableFind                = 137
    BuiltinHashtableImport              = 138
    BuiltinHashtableSize                = 139
    BuiltinReduceAll                    = 140
    BuiltinConv3dTranspose              = 141
    BuiltinVarHandle                    = 142
    BuiltinReadVariable                 = 143
    BuiltinAssignVariable               = 144
    BuiltinBroadcastArgs                = 145
    BuiltinRandomStandardNormal         = 146
    BuiltinBucketize                    = 147
    BuiltinRandomUniform                = 148
    BuiltinMultinomial                  = 149
    BuiltinGelu                         = 150
    BuiltinDynamicUpdateSlice           = 151
    BuiltinRelu0To1                     = 152
    BuiltinUnsortedSegmentProd          = 153
    BuiltinUnsortedSegmentMax           = 154
    BuiltinUnsortedSegmentSum           = 155
    BuiltinAtan2                        = 156
    BuiltinUnsortedSegmentMin           = 157
    BuiltinSign                         = 158
    BuiltinBitcast                      = 159
    BuiltinBitwiseXor                   = 160
    BuiltinRightShift                   = 161
    BuiltinStablehloLogistic            = 162
    BuiltinStablehloAdd                 = 163
    BuiltinStablehloDivide              = 164
    BuiltinStablehloMultiply            = 165
    BuiltinStablehloMaximum             = 166
    BuiltinStablehloReshape             = 167
    BuiltinStablehloClamp               = 168
    BuiltinStablehloConcatenate         = 169
    BuiltinStablehloBroadcastInDim      = 170
    BuiltinStablehloConvolution         = 171
    BuiltinStablehloSlice               = 172
    BuiltinStablehloCustomCall          = 173
    BuiltinStablehloReduce              = 174
    BuiltinStablehloAbs                 = 175
    BuiltinStablehloAnd                 = 176
    BuiltinStablehloCosine              = 177
    BuiltinStablehloExponential         = 178
    BuiltinStablehloFloor               = 179
    BuiltinStablehloLog                 = 180
    BuiltinStablehloMinimum             = 181
    BuiltinStablehloNegate              = 182
    BuiltinStablehloOr                  = 183
    BuiltinStablehloPower               = 184
    BuiltinStablehloRemainder           = 185
    BuiltinStablehloRsqrt               = 186
    BuiltinStablehloSelect              = 187
    BuiltinStablehloSubtract            = 188
    BuiltinStablehloTanh                = 189
    BuiltinStablehloScatter             = 190
    BuiltinStablehloCompare             = 191
    BuiltinStablehloConvert             = 192
    BuiltinStablehloDynamicSlice        = 193
    BuiltinStablehloDynamicUpdateSlice  = 194
    BuiltinStablehloPad                 = 195
    BuiltinStablehloIota                = 196
    BuiltinStablehloDotGeneral          = 197
    BuiltinStablehloReduceWindow        = 198
    BuiltinStablehloSort                = 199
    BuiltinStablehloWhile               = 200
    BuiltinStablehloGather              = 201
    BuiltinStablehloTranspose           = 202
  end
  fun interpreter_options_add_custom_op = TfLiteInterpreterOptionsAddCustomOp(options : InterpreterOptions, name : LibC::Char*, registration : LibC::Int*, min_version : Int32T, max_version : Int32T)
  fun interpreter_options_set_op_resolver_external = TfLiteInterpreterOptionsSetOpResolverExternal(options : InterpreterOptions, find_builtin_op : (Void*, LibC::Int, LibC::Int -> LibC::Int*), find_custom_op : (Void*, LibC::Char*, LibC::Int -> LibC::Int*), op_resolver_user_data : Void*)
  fun interpreter_options_set_op_resolver_external_with_fallback = TfLiteInterpreterOptionsSetOpResolverExternalWithFallback(options : InterpreterOptions, find_builtin_op_external : (Void*, LibC::Int, LibC::Int -> LibC::Int*), find_custom_op_external : (Void*, LibC::Char*, LibC::Int -> LibC::Int*), find_builtin_op : (Void*, BuiltinOperator, LibC::Int -> LibC::Int*), find_custom_op : (Void*, LibC::Char*, LibC::Int -> LibC::Int*), op_resolver_user_data : Void*)
  fun interpreter_options_set_op_resolver = TfLiteInterpreterOptionsSetOpResolver(options : InterpreterOptions, find_builtin_op : (Void*, BuiltinOperator, LibC::Int -> LibC::Int*), find_custom_op : (Void*, LibC::Char*, LibC::Int -> LibC::Int*), op_resolver_user_data : Void*)
  fun interpreter_options_set_op_resolver_v3 = TfLiteInterpreterOptionsSetOpResolverV3(options : InterpreterOptions, find_builtin_op_v3 : (Void*, BuiltinOperator, LibC::Int -> LibC::Int*), find_custom_op_v3 : (Void*, LibC::Char*, LibC::Int -> LibC::Int*), op_resolver_user_data : Void*)
  fun interpreter_options_set_op_resolver_v2 = TfLiteInterpreterOptionsSetOpResolverV2(options : InterpreterOptions, find_builtin_op_v2 : (Void*, BuiltinOperator, LibC::Int -> LibC::Int*), find_custom_op_v2 : (Void*, LibC::Char*, LibC::Int -> LibC::Int*), op_resolver_user_data : Void*)
  fun interpreter_options_set_op_resolver_v1 = TfLiteInterpreterOptionsSetOpResolverV1(options : InterpreterOptions, find_builtin_op_v1 : (Void*, BuiltinOperator, LibC::Int -> LibC::Int*), find_custom_op_v1 : (Void*, LibC::Char*, LibC::Int -> LibC::Int*), op_resolver_user_data : Void*)
  fun interpreter_create_with_selected_ops = TfLiteInterpreterCreateWithSelectedOps(model : Model, options : InterpreterOptions) : Interpreter
  fun interpreter_options_set_use_nnapi = TfLiteInterpreterOptionsSetUseNNAPI(options : InterpreterOptions, enable : LibC::Int)
  fun interpreter_options_set_enable_delegate_fallback = TfLiteInterpreterOptionsSetEnableDelegateFallback(options : InterpreterOptions, enable : LibC::Int)
  fun set_allow_buffer_handle_output = TfLiteSetAllowBufferHandleOutput(interpreter : Interpreter, allow_buffer_handle_output : LibC::Int)
  fun interpreter_modify_graph_with_delegate = TfLiteInterpreterModifyGraphWithDelegate(interpreter : Interpreter, delegate : Delegate) : Status
  type Delegate = Void*
  fun interpreter_get_input_tensor_index = TfLiteInterpreterGetInputTensorIndex(interpreter : Interpreter, input_index : Int32T) : Int32T
  fun interpreter_get_output_tensor_index = TfLiteInterpreterGetOutputTensorIndex(interpreter : Interpreter, output_index : Int32T) : Int32T
  fun interpreter_get_signature_count = TfLiteInterpreterGetSignatureCount(interpreter : Interpreter) : Int32T
  fun interpreter_get_signature_key = TfLiteInterpreterGetSignatureKey(interpreter : Interpreter, signature_index : Int32T) : LibC::Char*
  fun interpreter_get_signature_runner = TfLiteInterpreterGetSignatureRunner(interpreter : Interpreter, signature_key : LibC::Char*) : SignatureRunner
  type SignatureRunner = Void*
  fun signature_runner_get_input_count = TfLiteSignatureRunnerGetInputCount(signature_runner : SignatureRunner) : LibC::SizeT
  fun signature_runner_get_input_name = TfLiteSignatureRunnerGetInputName(signature_runner : SignatureRunner, input_index : Int32T) : LibC::Char*
  fun signature_runner_resize_input_tensor = TfLiteSignatureRunnerResizeInputTensor(signature_runner : SignatureRunner, input_name : LibC::Char*, input_dims : LibC::Int*, input_dims_size : Int32T) : Status
  fun signature_runner_allocate_tensors = TfLiteSignatureRunnerAllocateTensors(signature_runner : SignatureRunner) : Status
  fun signature_runner_get_input_tensor = TfLiteSignatureRunnerGetInputTensor(signature_runner : SignatureRunner, input_name : LibC::Char*) : Tensor
  fun signature_runner_invoke = TfLiteSignatureRunnerInvoke(signature_runner : SignatureRunner) : Status
  fun signature_runner_get_output_count = TfLiteSignatureRunnerGetOutputCount(signature_runner : SignatureRunner) : LibC::SizeT
  fun signature_runner_get_output_name = TfLiteSignatureRunnerGetOutputName(signature_runner : SignatureRunner, output_index : Int32T) : LibC::Char*
  fun signature_runner_get_output_tensor = TfLiteSignatureRunnerGetOutputTensor(signature_runner : SignatureRunner, output_name : LibC::Char*) : Tensor
  fun signature_runner_cancel = TfLiteSignatureRunnerCancel(signature_runner : SignatureRunner) : Status
  fun signature_runner_delete = TfLiteSignatureRunnerDelete(signature_runner : SignatureRunner)
  # fun interpreter_options_set_telemetry_profiler = TfLiteInterpreterOptionsSetTelemetryProfiler(options : InterpreterOptions, profiler : TelemetryProfilerStruct*)
end

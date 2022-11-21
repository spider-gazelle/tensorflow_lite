require "tensorflow_lite"
require "option_parser"
require "stumpy_jpeg"
require "stumpy_png"
require "stumpy_utils"
require "image_size"

# some other models
# https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/tf1_detection_zoo.md#mobile-models

puts "loading tensor model... can inspect using https://github.com/lutzroeder/netron\n\n"
client = TensorflowLite::Client.new("./assets/starter_model.tflite")
puts "input tensor layers: #{client.input_tensor_count}"
client.each do |tensor|
  puts "--- input: #{tensor.name}"
  puts "\ttype: #{tensor.type}"
  begin
    puts "\tinputs: #{tensor.io_count}"
  rescue
    puts "\tbytesize: #{tensor.bytesize}"
  end
  puts "\tdimensions: #{tensor.map(&.to_s).join("x")}"
end

inp_tensor = client[0]
required_width = inp_tensor[1]
required_height = inp_tensor[2]
puts "Tensor Input size is resolution x rgb (#{required_width}x#{required_height}x3)\n\n"

puts "output layer count: #{client.output_tensor_count}: bounding-boxes, classes, scores, count"
client.outputs.each do |tensor|
  puts "--- output: #{tensor.name}"
  puts "\ttype: #{tensor.type}"
  begin
    puts "\toutputs: #{tensor.io_count}"
  rescue
    puts "\tbytesize: #{tensor.bytesize}"
  end
  puts "\tdimensions: #{tensor.map(&.to_s).join("x")}"
end

label_path = "./assets/labelmap.txt"
image_path = "./assets/input.jpg"
output_image = "output"

OptionParser.parse(ARGV.dup) do |parser|
  parser.banner = "Usage: object_detection [arguments]"

  parser.on("-i IMAGE", "--image=IMAGE", "The image we want to detect objects in") do |img|
    image_path = img.strip if img.presence
  end

  parser.on("-l LABELS", "--labels=LABELS", "The list of labels") do |img|
    label_path = img.strip if img.presence
  end

  parser.on("-o OUTPUT", "--output=OUTPUT", "Name of the file we want to write the detections to") do |img|
    output_image = img.strip if img.presence
  end

  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit 0
  end
end

unless File.exists?(image_path)
  puts "input image file not found"
  exit 1
end

# loading the labels
labels = {} of Int32 => String
if File.exists?(label_path)
  idx = 0
  File.each_line(label_path) do |line|
    labels[idx] = line
    idx += 1
  end
end

# File type detection
# https://github.com/sindresorhus/file-type/blob/main/core.js

MAGIC_JPEG = Bytes[0xFF, 0xD8, 0xFF]

# Grab the current size of the image
file = File.new image_path
bytes = Bytes.new file.size
file.read_fully bytes
file.close
io = IO::Memory.new(bytes)

canvas = if bytes[0...3] == MAGIC_JPEG
           StumpyJPEG.read(io)
         else
           StumpyPNG.read(io)
         end

puts "\ninput image is #{canvas.width}x#{canvas.height}, resizing to #{required_width}x#{required_height}"

# If the image isn't square then we need to crop it
if canvas.width != canvas.height
  new_size = {canvas.width, canvas.height}.min
  cropped = StumpyCore::Canvas.new(new_size, new_size)

  if new_size == canvas.height
    pillarbox = true
    letterbox = false
    skip = (canvas.width - new_size) // 2
  else
    pillarbox = false
    letterbox = true
    skip = (canvas.height - new_size) // 2
  end

  row = -1
  canvas.each_row do |pixels|
    row += 1
    row_i = row
    if letterbox
      next if row < skip
      break if row == cropped.height + skip
      row_i = row - skip
    end

    col = -1
    pixels.each do |rgba|
      col += 1
      col_i = col
      if pillarbox
        next if col < skip
        break if col == cropped.width + skip
        col_i = col - skip
      end

      cropped.pixels[(row_i * cropped.width) + col_i] = rgba
    end
  end

  canvas = cropped
end
original_cropped = canvas

# convert to byte array so we can resize the image
io = IO::Memory.new
StumpyPNG.write(canvas, io)
bytes = io.to_slice

# resize the image for the NN
# FIX:: this will squash non-square images, we probably want to cut off the edges
# then we can provide a detection area
io = IO::Memory.new(ImageSize.resize bytes, width: required_width, height: required_height)
file_bytes = io.to_slice[0...3]

canvas = if file_bytes == MAGIC_JPEG
           StumpyJPEG.read(io)
         else
           StumpyPNG.read(io)
         end

raise "canvas should be #{required_width}x#{required_height}, got #{canvas.width}x#{canvas.height}" unless canvas.width == required_width && canvas.height == required_height

# convert the image into something the model can read (red, green, blue values for each pixel)
# this model is not quantized
# and set the input data on the tensors
inputs = client[0].as_u8
canvas.pixels.each_with_index do |rgb, index|
  idx = index * 3
  # we need to move the images colour space into the desired range
  inputs[idx] = ((rgb.r / UInt16::MAX) * UInt8::MAX).round.to_u8
  inputs[idx + 1] = ((rgb.g / UInt16::MAX) * UInt8::MAX).round.to_u8
  inputs[idx + 2] = ((rgb.b / UInt16::MAX) * UInt8::MAX).round.to_u8
end

# run the detection
client.invoke!

record Detection, top : Float32, left : Float32, bottom : Float32, right : Float32, classification : Int32, name : String?, score : Float32 do
  def lines(height, width)
    height = height.to_f32
    width = width.to_f32

    top_px = (top * height).round.to_i
    bottom_px = (bottom * height).round.to_i
    left_px = (left * width).round.to_i
    right_px = (right * width).round.to_i

    {
      # top line
      {left_px, top_px, right_px, top_px},
      # left line
      {left_px, top_px, left_px, bottom_px},
      # right line
      {right_px, top_px, right_px, bottom_px},
      # bottom line
      {left_px, bottom_px, right_px, bottom_px},
    }
  end
end

# collate the results (convert bounding boxes from pixels to percentages)
outputs = client.outputs

boxes = outputs[0].as_f32
features = outputs[1].as_f32
scores = outputs[2].as_f32
detection_count = outputs[3].as_f32[0].to_i

puts "\ndetected objects: #{detection_count}"

detections = (0...detection_count).map do |index|
  idx = index * 4
  klass = features[index].to_i
  Detection.new(
    top: boxes[idx],
    left: boxes[idx + 1],
    bottom: boxes[idx + 2],
    right: boxes[idx + 3],
    classification: klass,
    name: labels[klass]?,
    score: scores[index]
  )
end

pp detections

puts "\nWriting output file #{output_image}.png"

font = PCFParser::Font.from_file("./assets/font.pcf")

# Draw the detections onto the original image
detections.each do |detection|
  next if detection.score < 0.4_f32

  lines = detection.lines(original_cropped.width, original_cropped.height)
  lines.each do |line|
    original_cropped.line(*line)
  end

  if label = labels[detection.classification]?
    original_cropped.text(lines[0][0], lines[0][1], label, font)
  end
end

StumpyPNG.write(original_cropped, "./#{output_image}.png")

puts "Done!"

require "option_parser"
require "compress/zip"
require "file_utils"

tflite_path = ""
output_folder = "./metadata"

OptionParser.parse(ARGV.dup) do |parser|
  parser.banner = "Usage: metadata_extract [arguments]"

  parser.on("-t TFLITE", "--tflite=TFLITE", "The model we want to grab the metadata from") do |model|
    tflite_path = model.strip if model.presence
  end

  parser.on("-o OUTPUT", "--output=OUTPUT", "The output folder we want to extract the files") do |folder|
    output_folder = folder.strip if folder.presence
  end

  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit 0
  end
end

unless File.exists?(tflite_path)
  puts "input tl_lite model file not found, use `-t filename.tflite` to specify"
  exit 1
end

FileUtils.mkdir_p(output_folder)

# File type detection
# https://github.com/sindresorhus/file-type/blob/main/core.js
# https://en.wikipedia.org/wiki/ZIP_(file_format)

MAGIC_ZIP = Bytes[0x50, 0x4b, 0x03, 0x04]

# TFLite files might come with the label map, this extracts that
# https://www.tensorflow.org/lite/models/convert/metadata#model_with_metadata_format

file = File.new tflite_path
bytes = Bytes.new file.size
file.read_fully bytes
file.close

io = IO::Memory.new(bytes)
found = 0
read_buffer = Bytes.new(4)
remaining = bytes.size

# run through the file looking for possible zip headers
# then extract the zip file contents
while remaining >= 4
  read_pos = io.pos
  io.read_fully read_buffer

  if read_buffer == MAGIC_ZIP
    begin
      zip_data = IO::Memory.new(bytes[read_pos..-1])
      Compress::Zip::Reader.open(zip_data) do |zip|
        zip.each_entry do |entry|
          if entry.file?
            found += 1
            puts "  ->  #{entry.filename}"
            File.write(File.join(output_folder, entry.filename), entry.io)
          end
        end
      end
      break
    rescue Compress::Zip::Error
    end
  end

  io.pos = read_pos + 1
  remaining = bytes.size - io.pos
end

if found > 0
  puts "found #{found} metadata file(s)!"
  exit 0
end

puts "no metadata files found in file"

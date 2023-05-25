require "compress/zip"
require "file_utils"

module TensorflowLite::Utilities::ExtractLabels
  # File type detection
  # https://github.com/sindresorhus/file-type/blob/main/core.js
  # https://en.wikipedia.org/wiki/ZIP_(file_format)
  MAGIC_ZIP = Bytes[0x50, 0x4b, 0x03, 0x04]

  # extracts the label names from tensorflow lite model at the path specified
  def self.from(input : Path | Bytes, metadata_file : String = ".txt") : Hash(Int32, String)?
    # TODO:: we should update this to search the file more optimally
    # and work more memory effciently
    bytes = case input
            in Path
              File.open(input, &.getb_to_end)
            in Bytes
              input
            end

    io = IO::Memory.new(bytes)
    found = 0
    files = [] of String
    read_buffer = Bytes.new(MAGIC_ZIP.bytesize)
    remaining = bytes.size

    # run through the file looking for possible zip headers
    # then extract the zip file contents
    while remaining >= MAGIC_ZIP.bytesize
      read_pos = io.pos
      io.read_fully read_buffer

      if read_buffer == MAGIC_ZIP
        begin
          zip_data = IO::Memory.new(bytes[read_pos..-1])
          Compress::Zip::Reader.open(zip_data) do |zip|
            zip.each_entry do |entry|
              if entry.file?
                found += 1
                Log.debug { "found file -> #{entry.filename}" }
                # File.write(File.join(output_folder, entry.filename), entry.io)

                # loading the labels
                if entry.filename.ends_with?(metadata_file)
                  labels = {} of Int32 => String

                  idx = 0
                  entry.io.each_line do |line|
                    labels[idx] = line
                    idx += 1
                  end

                  return labels
                else
                  files << entry.filename
                end
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

    Log.info { "found #{found} files, no matches: #{files.join(", ")}" }

    nil
  end
end

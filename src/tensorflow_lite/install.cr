require "option_parser"
require "compress/zip"
require "file_utils"
require "http"
require "json"
require "dir"

# defaults
shards_install = nil

# Command line options
OptionParser.parse(ARGV.dup) do |parser|
  parser.on("-i", "--install", "install the libs in the parent application folders") do
    shards_install = "IS_LIB"
  end

  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit 0
  end
end

# we'll grab the binaries out of maven and only build if that fails
module TensorflowLite::Install
  extend self

  GROUP_ID  = "org.tensorflow"
  ARTIFACTS = {
    "tensorflow-lite" => {
      remote: "libtensorflowlite_jni.so",
      local:  "libtensorflowlite_c.so",
    },
    "tensorflow-lite-gpu" => {
      remote: "libtensorflowlite_gpu_jni.so",
      local:  "libtensorflowlite_gpu.so",
    },
  }

  def fetch_latest_maven_url(group_id : String, artifact_id : String) : String
    base_url = %(https://search.maven.org/solrsearch/select?q=g:%22#{group_id}%22+AND+a:%22#{artifact_id}%22&rows=1&wt=json)
    response = HTTP::Client.get(base_url)
    unless response.success?
      raise "Failed to fetch the artifact information: HTTP #{response.status_code}"
    end

    # Extract the latest version
    parsed = JSON.parse(response.body)
    latest_version = parsed["response"]["docs"].as_a[0]["latestVersion"].as_s

    # Construct the URL for download
    "https://repo1.maven.org/maven2/#{group_id.gsub('.', '/')}/#{artifact_id}/#{latest_version}/#{artifact_id}-#{latest_version}.aar"
  end

  def install_libs(as_lib)
    manual_build = {% if flag?(:x86_64) || flag?(:aarch64) %} false {% else %} true {% end %}
    arch_folder = {% if flag?(:x86_64) %} "x86_64" {% elsif flag?(:aarch64) %} "arm64-v8a" {% else %} nil {% end %}

    return build_tensorflowlite(as_lib) if manual_build

    FileUtils.mkdir_p("./ext")

    ARTIFACTS.each do |id, files|
      puts "downloading #{id} lib..."
      url = fetch_latest_maven_url(GROUP_ID, id)
      zip_file = File.tempname(id, ".zip")

      begin
        HTTP::Client.get(url) do |response|
          raise "download of #{id} from #{url} failed with #{response.status_code}" unless response.success?
          File.write(zip_file, response.body_io)
        end

        zipped_file = File.join("jni", arch_folder, files[:remote])
        local_file = File.join("./ext", files[:local])
        puts "extracting #{id} lib from #{zipped_file}..."

        Compress::Zip::File.open(zip_file) do |file|
          entry = file[zipped_file]
          entry.open { |io| File.write(local_file, io) }
        end
      ensure
        FileUtils.rm_rf(zip_file)
      end
    end

    # if this was installed as a library then we need to copy the
    # lib files into the parent dir for simplified development
    if as_lib
      FileUtils.mkdir("../../../bin/")

      # TODO:: might be better to sym link these libs
      Dir.new("./ext").entries.each do |file|
        next if file.starts_with?(".")
        source = File.join("./ext", file)
        dest1 = File.join("../../../", file)
        dest2 = File.join("../../../bin/", file)

        File.copy(source, dest1)
        File.copy(source, dest2)
      end
    end
  end

  # not quite as good as the maven files as I fail to build the GPU delegate
  def build_tensorflowlite(shards_install)
    `/bin/sh ./build_tensorflowlite.sh #{shards_install}`
  end
end

TensorflowLite::Install.install_libs(shards_install)

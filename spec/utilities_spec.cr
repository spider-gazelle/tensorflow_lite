require "./spec_helper"

module TensorflowLite
  SPEC_TF_L_MODEL = Path.new "./bin/mobilenet_v1.tflite"

  unless File.exists? SPEC_TF_L_MODEL
    puts "downloading tensorflow model for spec..."
    # details: https://tfhub.dev/tensorflow/lite-model/ssd_mobilenet_v1/1/metadata/2
    HTTP::Client.get("https://storage.googleapis.com/tfhub-lite-models/tensorflow/lite-model/ssd_mobilenet_v1/1/metadata/2.tflite") do |response|
      raise "could not download tf model file" unless response.success?
      File.write(SPEC_TF_L_MODEL, response.body_io)
    end
  end

  describe Utilities::ExtractLabels do
    it "extracts the tensorflow model label map" do
      labels = Utilities::ExtractLabels.from(SPEC_TF_L_MODEL)
      labels.as(Hash(Int32, String)).size.should eq 90
    end
  end
end

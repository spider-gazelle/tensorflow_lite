require "./spec_helper"

module TensorflowLite
  SPEC_TF_L_MODEL = Path.new "./bin/mobilenet_v1.tflite"

  unless File.exists? SPEC_TF_L_MODEL
    Dir.mkdir_p "./bin/"

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

    it "a client can be inspected" do
      client = Client.new(SPEC_TF_L_MODEL)
      details = client.interpreter.inspect
      puts details
      details.should eq <<-STRING
      TensorflowLite::Interpreter(
        input count: 1
        input - normalized_input_image_tensor
          type: UInt8
          inputs: 270000
          dimensions: 1x300x300x3
        output count: 4
        output - TFLite_Detection_PostProcess
          type: Float32
          outputs: 40
          dimensions: 1x10x4
        output - TFLite_Detection_PostProcess:1
          type: Float32
          outputs: 10
          dimensions: 1x10
        output - TFLite_Detection_PostProcess:2
          type: Float32
          outputs: 10
          dimensions: 1x10
        output - TFLite_Detection_PostProcess:3
          type: Float32
          outputs: 1
          dimensions: 1
      )
      STRING
    end
  end
end

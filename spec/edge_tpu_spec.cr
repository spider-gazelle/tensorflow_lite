require "./spec_helper"

module TensorflowLite
  describe EdgeTPU do
    it "can print its version" do
      EdgeTPU.version.includes?("RuntimeVersion").should be_true
    end

    it "can list the devices available" do
      available = EdgeTPU.devices.size >= 0
      available.should be_true
    end

    it "add a delegate to the interpreter options" do
      # we have to skip this test if there is no hardware installed
      # however at least we know it compiles
      opts = InterpreterOptions.new
      pending!("no available TPU devices") unless EdgeTPU.devices.size > 0
      opts.add_delegate EdgeTPU.devices[0].to_delegate
    end

    it "executes using a TPU deletegate" do
      pending!("no available TPU devices") unless EdgeTPU.devices.size > 0

      model_path = Path.new File.join(__DIR__, "./test_data/xor_model_quantized_edgetpu.tflite")
      xor_test = {
        {input: {-128_i8, -128_i8}, result: 0},
        {input: {127_i8, -128_i8}, result: 1},
        {input: {-128_i8, 127_i8}, result: 1},
        {input: {127_i8, 127_i8}, result: 0},
      }

      delegate = EdgeTPU.devices[0].to_delegate
      client = TensorflowLite::Client.new(model_path, delegate: delegate)

      xor_test.each do |test|
        inputs = test[:input]
        expected = test[:result]

        # configure inputs
        ints = client[0].as_i8
        ints[0], ints[1] = inputs
        client[0].as_i8.should eq client[0].as_type.as(Slice(Int8))

        # run through NN
        client.invoke!

        # check results
        ints = client.output.as_i8
        result = ints[0] >= 0_i8 ? 1 : 0

        result.should eq expected
      end

      client.outputs.size.should eq 1
      client.output.should eq client.outputs[0]
    end
  end
end

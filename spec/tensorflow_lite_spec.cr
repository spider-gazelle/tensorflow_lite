require "./spec_helper"

module TensorflowLite
  describe TensorflowLite do
    model_path = Path.new File.join(__DIR__, "./test_data/xor_model.tflite")
    xor_test = {
      {input: {0.0_f32, 0.0_f32}, result: 0},
      {input: {1.0_f32, 0.0_f32}, result: 1},
      {input: {0.0_f32, 1.0_f32}, result: 1},
      {input: {1.0_f32, 1.0_f32}, result: 0},
    }
    invalid_threads_error = "num_threads should be >=0 or just -1 to let TFLite runtime set the value."

    it "init a model from a path and blob" do
      file_io = File.new(model_path)
      file_data = Bytes.new(file_io.size)
      file_io.read_fully(file_data)
      file_io.close

      {Model.new(model_path), Model.new(file_data)}.each do |model|
        opts = InterpreterOptions.new
        opts.on_error do |error_msg|
          puts "error was #{error_msg}"
        end
        interpreter = Interpreter.new(model, opts)

        xor_test.each do |test|
          inputs = test[:input]
          expected = test[:result]

          # configure inputs
          input_tensor = interpreter.input_tensor(0)
          input_tensor.raw_data.bytesize.should eq input_tensor.bytesize
          input_tensor.size.should eq 2

          floats = input_tensor.as_f32
          floats[0], floats[1] = inputs

          # run through NN
          interpreter.invoke!

          # check results
          output_tensor = interpreter.output_tensor(0)
          floats = output_tensor.as_f32
          result = (floats[0] + 0.5_f32).to_i

          result.should eq expected
        end
      end
    end

    it "it reports errors" do
      model = Model.new(model_path)
      opts = InterpreterOptions.new
      opts.num_threads(-4)

      last_error = ""
      opts.on_error do |error_msg|
        last_error = error_msg
      end

      interpreter = Interpreter.new(model, opts)

      # run through NN
      result = interpreter.invoke
      result.should eq Interpreter::Status::Ok

      last_error.should eq invalid_threads_error
    end

    it "works via the client" do
      last_error = ""
      client = Client.new(model_path, threads: -4) do |error_msg|
        last_error = error_msg
      end

      xor_test.each do |test|
        inputs = test[:input]
        expected = test[:result]

        # configure inputs
        floats = client[0].as_f32
        floats[0], floats[1] = inputs
        client[0].as_f32.should eq client[0].as_type.as(Slice(Float32))

        # run through NN
        client.invoke!

        # check results
        floats = client.output.as_f32
        result = (floats[0] + 0.5_f32).to_i

        result.should eq expected
      end

      last_error.should eq invalid_threads_error
      client.outputs.size.should eq 1
      client.output.should eq client.outputs[0]
    end

    it "downloads models if a URI is provided to the client" do
      model = URI.parse "https://raw.githubusercontent.com/google-coral/test_data/master/ssdlite_mobiledet_coco_qat_postprocess.tflite"
      labels = URI.parse "https://raw.githubusercontent.com/google-coral/test_data/master/coco_labels.txt"
      last_error = ""

      client = Client.new(model, labels: labels) do |error_msg|
        last_error = error_msg
      end

      last_error.should eq ""
      client.outputs.size.should eq 4
      client.labels.as(Array(String)).size.should eq 90
    end

    describe TensorflowLite do
      it "can add a GPU delegate" do
        # it will fallback to CPU for this test if there is no hardware installed
        # however at least we know it compiles
        file_io = File.new(model_path)
        file_data = Bytes.new(file_io.size)
        file_io.read_fully(file_data)
        file_io.close

        {Model.new(model_path), Model.new(file_data)}.each do |model|
          opts = InterpreterOptions.new
          opts.on_error do |error_msg|
            puts "error was #{error_msg}"
          end
          interpreter = Interpreter.new(model, opts)

          gpu = DelegateGPU.new
          interpreter.modify_graph_with_delegate gpu

          xor_test.each do |test|
            inputs = test[:input]
            expected = test[:result]

            # configure inputs
            input_tensor = interpreter.input_tensor(0)
            input_tensor.raw_data.bytesize.should eq input_tensor.bytesize
            input_tensor.size.should eq 2

            floats = input_tensor.as_f32
            floats[0], floats[1] = inputs

            # run through NN
            interpreter.invoke!

            # check results
            output_tensor = interpreter.output_tensor(0)
            floats = output_tensor.as_f32
            result = (floats[0] + 0.5_f32).to_i

            result.should eq expected
          end
        end
      end

      it "can add a GPU delegate to the client" do
        # it will fallback to CPU for this test if there is no hardware installed
        file_io = File.new(model_path)
        file_data = Bytes.new(file_io.size)
        file_io.read_fully(file_data)
        file_io.close

        {Model.new(model_path), Model.new(file_data)}.each do |model|
          client = TensorflowLite::Client.new(model, delegate: DelegateGPU.new)

          xor_test.each do |test|
            inputs = test[:input]
            expected = test[:result]

            # configure inputs
            floats = client[0].as_f32
            floats[0], floats[1] = inputs

            # run through NN
            client.invoke!

            # check results
            floats = client.output.as_f32
            result = (floats[0] + 0.5_f32).to_i

            result.should eq expected
          end
        end
      end
    end

    it "works with quantized models" do
      quant_path = Path.new File.join(__DIR__, "./test_data/xor_model_quantized.tflite")
      quantized_test = {
        {input: {-128_i8, -128_i8}, result: 0},
        {input: {127_i8, -128_i8}, result: 1},
        {input: {-128_i8, 127_i8}, result: 1},
        {input: {127_i8, 127_i8}, result: 0},
      }

      client = TensorflowLite::Client.new(quant_path)

      quantized_test.each do |test|
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

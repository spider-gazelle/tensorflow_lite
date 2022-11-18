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

      last_error.should eq "num_threads should be >=0 or just -1 to let TFLite runtime set the value."
    end
  end
end

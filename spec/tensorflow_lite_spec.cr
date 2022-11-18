require "./spec_helper"

module TensorflowLite
  describe TensorflowLite do
    xor_test = {
      {input: {0.0_f32, 0.0_f32}, result: 0},
      {input: {1.0_f32, 0.0_f32}, result: 1},
      {input: {0.0_f32, 1.0_f32}, result: 1},
      {input: {1.0_f32, 1.0_f32}, result: 0},
    }

    it "init a model from a path and blob" do
      model_path = Path.new File.join(__DIR__, "./test_data/xor_model.tflite")

      file_io = File.new(model_path)
      file_data = Bytes.new(file_io.size)
      file_io.read_fully(file_data)
      file_io.close

      {Model.new(model_path), Model.new(file_data)}.each do |model|
        opts = InterpreterOptions.new
        opts.set_thread_count(3)
        opts.set_error_reporter do |error_msg|
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
  end
end

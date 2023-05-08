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
      if EdgeTPU.devices.size > 0
        opts.add_delegate EdgeTPU.devices[0].to_delegate
      end
    end
  end
end

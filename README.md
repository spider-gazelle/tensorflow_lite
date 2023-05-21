# tensorflow_lite

[![CI](https://github.com/spider-gazelle/tensorflow_lite/actions/workflows/ci.yml/badge.svg)](https://github.com/spider-gazelle/tensorflow_lite/actions/workflows/ci.yml) A library for running TF Lite models

* once you've trained a model in TensorFlow you can convert it to [TF Lite](https://www.tensorflow.org/lite/models/convert/convert_models#command_line_tool_) for production use
* inspect the TF Lite model using [netron.app](https://netron.app/)
* some [good TF models](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/tf2_detection_zoo.md) for object detection (need conversion)

Also see the [project documentation](https://spider-gazelle.github.io/tensorflow_lite/TensorflowLite/Client.html)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     tensorflow_lite:
       github: spider-gazelle/tensorflow_lite
   ```

2. Run `shards install`

## Usage

See the specs for basic usage or have a look at [imagine](https://github.com/stakach/imagine/blob/master/src/imagine/models/example_object_detection.cr)

```crystal
require "tensorflow_lite"
```

you can use the example metadata extractor to obtain the metadata for TF Lite models downloaded from [tfhub.dev](https://tfhub.dev/s?deployment-format=lite)

### With and EdgeTPU

Such as a Coral USB device

```crystal
require "tensorflow_lite/edge_tpu"
```

To install the edge tpu delegate:

```bash
# Add Google Cloud public key
RUN wget -q -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/coral-edgetpu.gpg

# Add Coral packages repository
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/coral-edgetpu.gpg] https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list

# install the lib
sudo apt update
sudo apt install libedgetpu-dev
```

To install the [Coral USB drivers](https://coral.ai/docs/accelerator/get-started/#requirements)

```bash
sudo apt install libedgetpu1-std
# OR for max frequency
sudo apt install libedgetpu1-max

# unplug and re-plug the coral or run this
sudo systemctl restart udev
```

NOTE:: when using a coral and running `lsusb` you need to look for either:

* Global Unichip Corp.
* Google Inc.

after running something on the chip it will [change identity to Google Inc.](https://www.reddit.com/r/Proxmox/comments/nmsknx/proxmox_vm_ubuntu_2004_connect_google_coral_usb/)

And you need to include the Google identity version in any docker files.

## Development

To update tensorflow lite bindings `./generate_bindings.sh`

### lib installation

Requires [libtensorflow](https://www.tensorflow.org/install/lang_c) to be installed, this is handled automatically by `./build_tensorflowlite.sh`

* there is a [guide to building it](https://www.tensorflow.org/lite/guide/build_cmake)
* you can use `./build_tensorflowlite.sh` to automate this
* then requires `export LD_LIBRARY_PATH=/usr/local/lib` to run
* test if installed successfully `crystal ./src/tensorflow_lite.cr`
  * this will output `Launching with tensorflow lite vx.x.x`

NOTE:: the lib is installed for local use via a postinstall script.
Make sure to distribute `libtensorflowlite_c.so` with your production app

## Contributing

1. Fork it (<https://github.com/your-github-user/tensorflow_lite/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

* [Stephen von Takach](https://github.com/stakach) - creator and maintainer

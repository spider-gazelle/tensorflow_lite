# Object Detection

This example does the following:

1. loads the TF Lite model and extracts the input resolution
1. loads in the optional label metadata (defaults to `./assets/labelmap.txt`)
1. crops the input image (defaults to `./assets/input.jpg`)
1. resizes the cropped image
1. sets the input tensor values to the image RGB values
1. invokes the neural net
1. parses the output and prints it
1. applys the detection data to the cropped image (image before it was re-sized)
1. writes the output as an image (defaults to `./output.png`)

## Usage

Options are:

* help `-h`
* input image `-i ./input.png` (image must be same size or larger than tf model expects)
* list of labels `-l ./labelmap.txt` (one label per-line)
* output image `-o ./output` (will append `.png` to the output file)

```bash
shards build
./bin/object_detection
```

## Example assets

TF Lite Model: https://tfhub.dev/tensorflow/lite-model/ssd_mobilenet_v1/1/metadata/1

* label map extracted using the extract metadata helper
* other metadata can be viewed using [netron.app](https://netron.app/)
* implementing the [tensorflow object detection example](https://www.tensorflow.org/lite/examples/object_detection/overview)

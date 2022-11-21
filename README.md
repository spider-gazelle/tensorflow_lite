# tensorflow_lite

A library for running TF

## Installation

1. Requires [libtensorflow](https://www.tensorflow.org/install/lang_c) to be installed
   * there is a [guide to building it](https://www.tensorflow.org/lite/guide/build_cmake)
   * you can use `./build_tensorflowlite.sh` to automate this
   * then requires `export LD_LIBRARY_PATH=/usr/local/lib` to run
   * test if installed successfully `crystal ./src/tensorflow_lite.cr`
      * this will output `Launching with tensorflow lite vx.x.x`

2. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     tensorflow_lite:
       github: spider-gazelle/tensorflow_lite
   ```

3. Run `shards install`

## Usage

```crystal
require "tensorflow_lite"
```

you can use the example metadata extractor to obtain the metadata for TF Lite models downloaded from [tfhub.dev](https://tfhub.dev/s?deployment-format=lite)

## Development

To update tensorflow lite bindings `./generate_bindings.sh` the resulting file needs one modification currently:

* Replace all instances of `LibC::Bool` with `LibC::SizeT`

there is an issue tracking [this problem](https://github.com/crystal-lang/crystal_lib/issues/78).

## Contributing

1. Fork it (<https://github.com/your-github-user/tensorflow_lite/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

* [Stephen von Takach](https://github.com/stakach) - creator and maintainer

# python3 -m venv tfliteenv
# source tfliteenv/bin/activate
# pip install tensorflow numpy matplotlib pandas

# Workarond for failing to compile tflite model
# pip install -U tf_keras
import os
os.environ["TF_USE_LEGACY_KERAS"] = "1"

import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation
from tensorflow.keras.optimizers import SGD

# Define the model
model = Sequential([
    Dense(8, input_dim=2, activation='tanh'),
    Dense(1, activation='sigmoid')
])

# Compile the model
model.compile(loss='binary_crossentropy', optimizer=SGD(learning_rate=0.1))

# Fit the model
model.fit(
    np.array([[0, 0], [0, 1], [1, 0], [1, 1]]),
    np.array([[0], [1], [1], [0]]),
    batch_size=1, epochs=300
)

# Save the model
model.save('xor_model.keras')

# ==============================
# Save tflite model
# ==============================

# Load the already trained Keras model
model = tf.keras.models.load_model('xor_model.keras')

# Prepare the converter for the TensorFlow Lite format
converter = tf.lite.TFLiteConverter.from_keras_model(model)

# Convert the model to TensorFlow Lite format
tflite_model = converter.convert()

# Save the TensorFlow Lite model to a binary file
with open('xor_model.tflite', 'wb') as f:
    f.write(tflite_model)

print("Model has been successfully converted to TensorFlow Lite format.")

# ==============================
# Save quantizes tflite model
# ==============================

# Representative dataset function
def representative_dataset_gen():
    for _ in range(100):  # Adjust the number based on desired dataset size
        # Generate a batch of inputs that are only 0.0 or 1.0, matching the expected real input
        yield [np.random.choice([0.0, 1.0], size=(1, 2)).astype(np.float32)]

# Load the model
model = tf.keras.models.load_model('xor_model.keras')

# Convert the model using TensorFlow Lite with Quantization
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.representative_dataset = representative_dataset_gen
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
converter.inference_input_type = tf.int8  # Use int8 input
converter.inference_output_type = tf.int8  # Use int8 output

# Convert the model
tflite_quant_model = converter.convert()

# Save the quantized model
with open('xor_model_quantized.tflite', 'wb') as f:
    f.write(tflite_quant_model)

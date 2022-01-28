import 'dart:io';
import 'dart:math';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class TensorflowProvider {
  // Singleton
  TensorflowProvider._internal();

  static Future<TensorflowProvider> create() async {
    TensorflowProvider provider = TensorflowProvider._internal();
    await provider.loadModel();
    await provider.loadLabels();
    return provider;
  }

  static Future<TensorflowProvider> get() async {
    if (_instance == null) {
      _instance = await TensorflowProvider.create();
    }
    return _instance!;
  }

  static TensorflowProvider? _instance;

  late List<String> _labels;
  late Interpreter _interpreter;
  late List<int> _outputShape;
  late TfLiteType _outputType;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset("mobilenet.tflite");
    _outputShape = _interpreter.getOutputTensor(0).shape;
    _outputType = _interpreter.getOutputTensor(0).type;
  }

  Future<void> loadLabels() async {
    _labels = await FileUtil.loadLabels("assets/labels.txt");
  }

  List<Category> recognize(File imageFile) {
    TensorImage tensorImage = TensorImage.fromFile(imageFile);
    int cropSize = min(tensorImage.height, tensorImage.width);
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
        .build();
    tensorImage = imageProcessor.process(tensorImage);

    TensorBuffer probabilityBuffer =
        TensorBuffer.createFixedSize(_outputShape, _outputType);
    _interpreter.run(tensorImage.buffer, probabilityBuffer.buffer);

    SequentialProcessor<TensorBuffer> probabilityProcessor =
        TensorProcessorBuilder().add(DequantizeOp(0, 1 / 255.0)).build();
    TensorBuffer dequantizedBuffer =
        probabilityProcessor.process(probabilityBuffer);

    TensorLabel tensorLabel = TensorLabel.fromList(_labels, dequantizedBuffer);
    return tensorLabel.getCategoryList()
      ..sort((a, b) => (b.score - a.score).toInt());
  }
}

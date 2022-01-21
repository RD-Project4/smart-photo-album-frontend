import 'dart:io';
import 'dart:math';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class TensorflowProvider {
  static Future<List<Category>> recognize(File imageFile) async {
    TensorImage tensorImage = TensorImage.fromFile(imageFile);
    int cropSize = min(tensorImage.height, tensorImage.width);
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
        .build();
    tensorImage = imageProcessor.process(tensorImage);

    List<String> labels = await FileUtil.loadLabels("assets/labels.txt");
    TensorBuffer probabilityBuffer =
        TensorBuffer.createFixedSize(<int>[1, 1001], TfLiteType.uint8);
    Interpreter interpreter = await Interpreter.fromAsset("mobilenet.tflite");
    interpreter.run(tensorImage.buffer, probabilityBuffer.buffer);

    SequentialProcessor<TensorBuffer> probabilityProcessor =
        TensorProcessorBuilder().add(DequantizeOp(0, 1 / 255.0)).build();
    TensorBuffer dequantizedBuffer =
        probabilityProcessor.process(probabilityBuffer);

    TensorLabel tensorLabel = TensorLabel.fromList(labels, dequantizedBuffer);
    return tensorLabel.getCategoryList()
      ..sort((a, b) => (b.score - a.score).toInt());
  }
}

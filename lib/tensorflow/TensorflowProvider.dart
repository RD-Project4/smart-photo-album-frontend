import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:smart_album/util/ServiceUtil.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class TensorflowProvider {
  static const String SERVICE_NAME = "TensorflowService";

  late List<String> _labels;
  late Interpreter _interpreter;
  late List<int> _outputShape;
  late TfLiteType _outputType;

  TensorflowProvider(ByteData model, String labels) {
    _loadModelFromByteData(model);
    _loadLabels(labels);
  }

  void _loadModelFromByteData(ByteData model) {
    _interpreter = Interpreter.fromBuffer(model.buffer.asUint8List(),
        options: InterpreterOptions()..useNnApiForAndroid = true);
    _outputShape = _interpreter.getOutputTensor(0).shape;
    _outputType = _interpreter.getOutputTensor(0).type;
  }

  void _loadLabels(String labels) {
    _labels = FileUtil.labelListFromString(labels);
  }

  static Future<List<Category>> recognizeFile(String path) async {
    Service service = await ServiceUtils.getService(
        SERVICE_NAME, TensorflowProvider._recognizeFileInService, {
      "model": await rootBundle.load("assets/model.tflite"),
      "labels": await rootBundle.loadString("assets/labels.txt")
    });
    return await service.execute(path);
  }

  static Future<void> _recognizeFileInService(
      SendPort sendPort, ReceivePort receivePort, Map? initArgs) async {
    if (initArgs == null) throw Exception("Can not init provider");
    TensorflowProvider? provider =
        TensorflowProvider(initArgs["model"], initArgs["labels"]);
    await for (final msg in receivePort) {
      sendPort.send(provider._recognizeFile(msg));
    }
  }

  List<Category> _recognizeFile(String path) {
    TensorImage tensorImage = TensorImage.fromFile(File(path));
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

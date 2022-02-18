import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart';

import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:smart_album/util/ServiceUtil.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class _Model {
  late Interpreter _interpreter;

  _Model(this._interpreter);

  List<TensorBuffer> run(TensorImage tensorImage) {
    List<TensorBuffer> result = [];
    Map<int, ByteBuffer> outputBuffer = _interpreter
        .getOutputTensors()
        .map((tensor) {
          var tensorBuffer =
              TensorBuffer.createFixedSize(tensor.shape, tensor.type);
          result.add(tensorBuffer);
          return tensorBuffer.buffer;
        })
        .toList()
        .asMap();
    _interpreter.runForMultipleInputs([tensorImage.buffer], outputBuffer);
    return result;
  }
}

class TensorflowProvider {
  static const String SERVICE_NAME = "TensorflowService";

  late List<String> _labels;
  late _Model objectModel;
  late _Model textModel;
  late _Model ocrModel;

  TensorflowProvider(ByteData objectModelByteData, String labels) {
    objectModel = _loadModelFromByteData(objectModelByteData);
    // ocrModel = _loadModelFromByteData(ocrModelByteData, useNnApi: false);
    _loadLabels(labels);
  }

  _Model _loadModelFromByteData(ByteData model, {useNnApi = true}) {
    InterpreterOptions options = InterpreterOptions()
      ..useNnApiForAndroid = useNnApi
      ..useMetalDelegateForIOS = true;
    return _Model(
        Interpreter.fromBuffer(model.buffer.asUint8List(), options: options));
  }

  void _loadLabels(String labels) {
    _labels = FileUtil.labelListFromString(labels);
  }

  static Service? _service;

  static Future<Service> getService() async {
    if (_service != null)
      return _service!;
    else
      return _service = await ServiceUtils.getService(
          SERVICE_NAME, TensorflowProvider._recognizeInService, {
        "objectModel": await rootBundle.load("assets/model.tflite"),
        "labels": await rootBundle.loadString("assets/labels.txt")
      });
  }

  static Future<void> _recognizeInService(
      SendPort sendPort, ReceivePort receivePort, Map? initArgs) async {
    if (initArgs == null) throw Exception("Can not init provider");
    TensorflowProvider? provider =
        TensorflowProvider(initArgs["objectModel"], initArgs["labels"]);
    await for (final msg in receivePort) {
      switch (msg["command"]) {
        case "recognizeObjectInFile":
          sendPort.send(provider._recognizeObjectInFile(msg["path"]));
          break;
        default:
          continue;
      }
    }
  }

  static Future<List<Category>> recognizeObjectInFile(String path) async {
    Service service = await getService();
    return await service
        .execute({"command": "recognizeObjectInFile", "path": path});
  }

  List<Category> _recognizeObjectInFile(String path) {
    TensorImage tensorImage = TensorImage.fromFile(File(path));
    int cropSize = min(tensorImage.height, tensorImage.width);
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
        .build();
    tensorImage = imageProcessor.process(tensorImage);

    TensorBuffer probabilityBuffer = objectModel.run(tensorImage)[0];

    SequentialProcessor<TensorBuffer> probabilityProcessor =
        TensorProcessorBuilder().add(DequantizeOp(0, 1 / 255.0)).build();
    TensorBuffer dequantizedBuffer =
        probabilityProcessor.process(probabilityBuffer);

    TensorLabel tensorLabel = TensorLabel.fromList(_labels, dequantizedBuffer);
    return tensorLabel.getCategoryList()
      ..sort((a, b) => (b.score - a.score).toInt());
  }

  static Future<String> recognizeTextInFile(String path) async {
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(InputImage.fromFilePath(path));
    return recognisedText.text;
  }
}

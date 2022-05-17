import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart';

import 'package:flutter/services.dart';
import 'package:smart_album/util/Labels.dart';
import 'package:smart_album/util/ServiceUtil.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class _Model {
  late Interpreter _interpreter;

  _Model(this._interpreter);

  processImage(File file, [imageTensorIndex = 0]) {
    var image = TensorImage(_interpreter.getInputTensor(imageTensorIndex).type);
    image.loadImage(decodeImage(file.readAsBytesSync())!);
    return image;
  }

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

  static const String OBJECT_MODEL_LOCATION = "assets/model.tflite";
  static const String LABELS_LOCATION = "assets/labels.txt";

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
        "objectModel": await rootBundle.load(OBJECT_MODEL_LOCATION),
        "labels": await rootBundle.loadString(LABELS_LOCATION)
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
    TensorImage tensorImage = objectModel.processImage(File(path));
    int cropSize = min(tensorImage.height, tensorImage.width);
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
        .add(NormalizeOp(0, 255))
        .build();
    tensorImage = imageProcessor.process(tensorImage);

    TensorBuffer probabilityBuffer = objectModel.run(tensorImage)[0];

    TensorLabel tensorLabel = TensorLabel.fromList(_labels, probabilityBuffer);
    return tensorLabel.getCategoryList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  static Future<List<String>> recognizeTextInFile(String path) async {
    final textDetector = TextRecognizer();
    final RecognizedText recognisedText =
        await textDetector.processImage(InputImage.fromFilePath(path));
    return recognisedText.blocks.map((block) => block.text).toList();
  }

  static List<String> getLabels() {
    List<String> labelList = [];
    for (var superCategory in superCategories) {
      labelList.addAll(superCategory.labels);
    }
    return labelList;
  }
}

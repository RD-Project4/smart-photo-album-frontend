import 'package:flutter/material.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'common/Global.dart';
import 'widgets/ColorfulProgressBar.dart';

class ChipBar<T extends dynamic> extends StatelessWidget {
  final T element;

  const ChipBar({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: TensorflowProvider.recognizeFile(
          Global.ROOT_PATH + element.relativePath + element.title),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null)
            ? Container(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: (snapshot.data as List<Category>)
                      .where((element) => element.score > 0.5)
                      .take(5)
                      .map((element) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Chip(label: Text(element.label))))
                      .toList(),
                ))
            : ColorfulProgressBar();
      },
    );
  }
}

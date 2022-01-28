import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'common/Global.dart';

class ChipBar<T extends dynamic> extends StatelessWidget {
  final T element;

  ChipBar({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: TensorflowProvider.recognize(
          File(Global.ROOT_PATH + element.relativePath + element.title)),
      initialData: List.empty(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            height: 60,
            child: snapshot.connectionState == ConnectionState.done
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: (snapshot.data as List<Category>)
                        .where((element) => element.score > 0.5)
                        .take(5)
                        .map((element) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Chip(label: Text(element.label))))
                        .toList(),
                  )
                : Chip(label: Text("Loading...")));
      },
    );
  }
}

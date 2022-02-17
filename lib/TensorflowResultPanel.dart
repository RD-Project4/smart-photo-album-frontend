import 'package:flutter/material.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';
import 'package:smart_album/util/Global.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'FolderPage.dart';
import 'widgets/ColorfulProgressBar.dart';

class TensorflowResultPanel {
  static open<T extends dynamic>(BuildContext context, T element) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
            height: 300,
            child: DefaultTabController(
                length: 2,
                child: Scaffold(
                    appBar: TabBar(
                      tabs: [
                        Tab(text: "Object"),
                        Tab(text: "Text"),
                      ],
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                    ),
                    body: TabBarView(children: [
                      FutureBuilder<List<Category>>(
                        future: TensorflowProvider.recognizeObjectInFile(
                            Global.ROOT_PATH +
                                element.relativePath +
                                element.title),
                        initialData: null,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data != null)
                              ? ListView(
                                  scrollDirection: Axis.vertical,
                                  children: (snapshot.data as List<Category>)
                                      .take(5)
                                      .where((element) => element.score > 100)
                                      .map((element) => Stack(
                                            children: [
                                              Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  child: Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: 400 *
                                                                  element
                                                                      .score /
                                                                  100000),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .lightBlueAccent,
                                                          shape: BoxShape
                                                              .rectangle))),
                                              ListTile(
                                                title: Text(element.label),
                                                onTap: () =>
                                                    Navigator.pushNamed(
                                                        context, '/folderPage',
                                                        arguments:
                                                            FolderPageArguments(
                                                                title: element
                                                                    .label)),
                                              )
                                            ],
                                          ))
                                      .toList())
                              : Stack(children: [
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: ColorfulProgressBar()),
                                ]);
                        },
                      ),
                      FutureBuilder<String>(
                          future: TensorflowProvider.recognizeTextInFile(
                              Global.ROOT_PATH +
                                  element.relativePath +
                                  element.title),
                          initialData: null,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null)
                                ? Text(snapshot.data)
                                : Stack(children: [
                                    Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: ColorfulProgressBar()),
                                  ]);
                          })
                    ])))));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SlidingUpPanel(
  //     borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
  //     header: Center(
  //         child: Column(children: [
  //       Text("Recognition result"),
  //       ElevatedButton(
  //           onPressed: () async {
  //             var a = await TensorflowProvider.recognizeTextInFile(
  //                 Global.ROOT_PATH + element.relativePath + element.title);
  //             print(a);
  //           },
  //           child: Text("recoginize text")),
  //     ])),
  //     panel: Center(
  //         child: FutureBuilder<List<Category>>(
  //       future: TensorflowProvider.recognizeObjectInFile(
  //           Global.ROOT_PATH + element.relativePath + element.title),
  //       initialData: null,
  //       builder: (BuildContext context, AsyncSnapshot snapshot) {
  //         return (snapshot.connectionState == ConnectionState.done &&
  //                 snapshot.data != null)
  //             ? Container(
  //                 child: ListView(
  //                     scrollDirection: Axis.vertical,
  //                     children: (snapshot.data as List<Category>)
  //                         .where((element) => element.score > 0.5)
  //                         .take(5)
  //                         .map((element) => ListTile(
  //                               title: Text(element.label),
  //                               onTap: () => Navigator.pushNamed(
  //                                   context, '/folderPage',
  //                                   arguments: FolderPageArguments(
  //                                       title: element.label)),
  //                             ))
  //                         .toList()))
  //             : ColorfulProgressBar();
  //       },
  //     )),
  //   );
  // }
}

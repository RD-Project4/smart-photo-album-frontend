import 'package:flutter/material.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';

import '../FolderPage.dart';
import 'ColorfulProgressBar.dart';

class TensorflowResultPanel {
  static open(BuildContext context, Photo element) async {
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
                      ListView(
                          scrollDirection: Axis.vertical,
                          children: element.labels
                              .take(5)
                              .map((label) => createLabel(context, label))
                              .toList()),
                      FutureBuilder<String>(
                          future: TensorflowProvider.recognizeTextInFile(
                              element.path),
                          initialData: null,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null)
                                ? Text((snapshot.data as String).isNotEmpty
                                    ? snapshot.data
                                    : "No text was found")
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

  static Widget createLabel(BuildContext context, String label) {
    return Stack(
      children: [
        // Positioned(
        //   top: 0,
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: FractionallySizedBox(
        //       widthFactor: element.score,
        //       heightFactor: 1.0,
        //       alignment: Alignment.centerLeft,
        //       child: DecoratedBox(
        //           decoration: BoxDecoration(
        //               color: Colors.lightBlueAccent,
        //               shape: BoxShape.rectangle))),
        // ),
        ListTile(
          title: Text(label),
          // onTap: () => Navigator.pushNamed(context, '/folderPage',
          //     arguments: FolderPageArguments(title: label)),
        )
      ],
    );
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/widgets/ListedChips.dart';
import 'package:smart_album/widgets/OutlineCard.dart';

import '../FolderPage.dart';

class TensorflowResultPanel {
  static open(BuildContext context, Photo element) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        builder: (BuildContext context) => DraggableScrollableSheet(
            expand: false,
            builder:
                (BuildContext context, ScrollController scrollController) =>
                    SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      controller: scrollController,
                      child: Column(
                        children: [
                          OutlineCard(
                              title: "Related to",
                              margin: const EdgeInsets.all(10),
                              child: ListedChips<String>(
                                buildLabel: (item) => Text(item),
                                itemList: element.labels,
                                onTap: (item) {
                                  Navigator.pushNamed(context, '/folderPage',
                                      arguments: FolderPageArguments(
                                          title: item,
                                          photoList: context
                                              .read<PhotoCubit>()
                                              .getPhotoListByLabel(item)));
                                },
                              )),
                          OutlineCard(
                              title: "Text",
                              margin: const EdgeInsets.all(10),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                      children: element.text
                                          .map((string) => Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                                child: Text(string),
                                              ))
                                          .toList())))
                        ],
                      ),
                    )));
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

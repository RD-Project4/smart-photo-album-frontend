import 'package:flutter/material.dart';

class PhotoFolderGridView<T extends Map> extends StatelessWidget {
  final List<T> photoList;

  const PhotoFolderGridView(this.photoList);

  @override
  Widget build(BuildContext context) {
    Map<String, List<T>> folderList = Map();
    photoList.forEach((photo) {
      if (photo["tag"] != null && photo["tag"] is List)
        for (var tag in photo["tag"]) {
          if (folderList[tag] == null) {
            folderList[tag] = [];
          }
          folderList[tag]!.add(photo);
        }
    });

    return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: folderList.entries
            .map((entry) => Padding(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[Colors.black, Colors.white],
                        ).createShader(bounds);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: AssetImage("images/" + entry.value[0]['name']),
                          fit: BoxFit.cover,
                        ),
                      )),
                    ),
                    Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(entry.key,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)))
                  ],
                )))
            .toList());
  }
}

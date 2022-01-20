import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/common/Global.dart';

class PhotoEditPage extends StatefulWidget {
  final AssetEntity entity;
  const PhotoEditPage({Key? key,required this.entity}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoEditPage();
}

class _PhotoEditPage extends State<PhotoEditPage> {
  bool ableToSave = false;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Image.file(File('${Global.ROOT_PATH}${widget.entity.relativePath}${widget.entity.title}')),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {},
                      child:
                          Text('Crop', style: TextStyle(color: Colors.white))),
                  TextButton(
                      onPressed: () {},
                      child: Text('Adjust',
                          style: TextStyle(color: Colors.white))),
                  TextButton(
                      onPressed: () {},
                      child:
                          Text('Markup', style: TextStyle(color: Colors.white)))
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      onPressed: ableToSave ? saveEditing : null,
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}

void saveEditing() {}

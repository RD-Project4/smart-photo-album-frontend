import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/util/Global.dart';
import 'package:group_button/group_button.dart';

class PhotoEditPage extends StatefulWidget {
  final AssetEntity entity;

  const PhotoEditPage({Key? key, required this.entity}) : super(key: key);

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
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Center(
              child: Image.file(File(
                  '${Global.ROOT_PATH}${widget.entity.relativePath}${widget.entity.title}'))),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GroupButton(
                isRadio: true,
                buttons: ['Crop', 'Adjust', 'Markup'],
                onSelected: (index,isSelected) => debugPrint('Button $index selected'),
                selectedButton: 0,  // 默认选中
                borderRadius: BorderRadius.circular(1000),
                selectedColor: Color.fromARGB(255, 68, 71, 70),
                selectedTextStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color.fromARGB(255,227, 227, 227),
                ),
                unselectedColor: Colors.black,
                unselectedTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color.fromARGB(255, 117, 117, 117),
                ),
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
                        style: TextStyle(
                            color: ableToSave ? Colors.white : Colors.grey),
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

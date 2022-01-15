import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';

class ListedPhoto extends StatefulWidget {
  final path;
  final onTap;

  const ListedPhoto({Key? key, required this.path, this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListedPhotoState();
}

class _ListedPhotoState extends State<ListedPhoto> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoListCubit, PhotoListMode>(
        builder: (context, state) {
      return InkWell(
          child: GestureDetector(
        child: Stack(
          children: [
            Container(
                margin: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(widget.path)),
                    fit: BoxFit.cover,
                  ),
                )),
            state == PhotoListMode.Selection
                ? Checkbox(
                    value: isChecked,
                    side: BorderSide(color: Colors.white, width: 2),
                    onChanged: (status) {},
                  )
                : Container()
          ],
        ),
        onTap: () {
          if (state == PhotoListMode.View) {
            widget.onTap();
          } else if (state == PhotoListMode.Selection) {
            setState(() {
              isChecked = !isChecked;
            });
          }
        },
        onLongPress: () {
          context.read<PhotoListCubit>().switchMode();
          setState(() {
            isChecked = !isChecked;
          });
        },
      ));
    });
  }
}

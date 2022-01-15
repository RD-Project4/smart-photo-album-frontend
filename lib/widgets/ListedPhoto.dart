import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/photo_list_mode/PhotoListModeCubit.dart';

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
          BlocBuilder<PhotoListModeCubit, PhotoListMode>(
            builder: (context, state) {
              return state == PhotoListMode.Selection ? Checkbox(
                value: isChecked,
                side: BorderSide(color: Colors.white, width: 2),
                onChanged: (status) {},
              ) : Container();
            },
          )
        ],
      ),
      onTap: () {
        widget.onTap();
      },
      onLongPress: () {
        context.read<PhotoListModeCubit>().switchMode();
        setState(() {
          isChecked = !isChecked;
        });
      },
    ));
  }
}

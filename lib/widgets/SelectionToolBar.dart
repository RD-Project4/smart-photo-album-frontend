import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';

/// 多选工具栏，当进入多选模式时出现在应用上方
class SelectionToolBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoListCubit, PhotoListState>(
        builder: (context, state) {
      return Container(
        color: Color.fromARGB(220, 194, 231, 255),
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                GestureDetector(
                  child: Icon(Icons.close),
                  onTap: () {
                    context.read<PhotoListCubit>()
                      ..setModeView()
                      ..clearSelectedPhotos();
                  },
                ),
                SizedBox(width: 10),
                Text('${state.selectedPhotos.length}',style: TextStyle(fontSize: 25),),
              ],
            ),
            Row(
              children: [
                Icon(Icons.share),
                SizedBox(width: 10),
                Icon(Icons.delete),
                SizedBox(width: 10),
                Icon(Icons.more_vert),
                SizedBox(width: 10),
              ],
            )
          ],
        ),
      );
    });
  }
}
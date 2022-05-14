import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/bloc/uploadManager/UploadCubit.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
import 'package:smart_album/util/ThemeUtil.dart';

class SelectionToolBar extends StatefulWidget {
  SelectionToolBar({Key? key}) : super(key: key);

  @override
  State<SelectionToolBar> createState() => _SelectionToolBarState();
}

class _SelectionToolBarState extends State<SelectionToolBar> {
  late Color originalStatusbarColor;

  @override
  void dispose() {
    super.dispose();
    ThemeUtil.setSystemOverlayLight(context,
        backgroundColor: originalStatusbarColor);
  }

  @override
  Widget build(BuildContext context) {
    originalStatusbarColor = ThemeUtil.getBackgroundColor(context);
    Color backgroundColor = Colors.blue.shade700;
    ThemeUtil.setSystemOverlayDark(context, backgroundColor: backgroundColor);

    return BlocBuilder<PhotoListCubit, PhotoListState>(
        builder: (context, state) {
      return AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => context.read<PhotoListCubit>()
            ..setModeView()
            ..clearSelectedPhotos(),
        ),
        title: Text('Selected ${state.selectedItems.length}'),
        actions: [
          IconButton(
              icon: Icon(Icons.file_upload_outlined),
              onPressed: () {
                if (!context.read<UserCubit>().isLogin()) {
                  showToast("Please login first");
                  return;
                }
                context
                    .read<UploadCubit>()
                    .uploadPhotoList(context, state.selectedItems.toList());
                context.read<PhotoListCubit>()
                  ..setModeView()
                  ..clearSelectedPhotos();
              }),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              state.selectedItems.forEach((photo) {
                context.read<PhotoCubit>().movePhotoToTrashBin(photo);
              });
              context.read<PhotoListCubit>()
                ..setModeView()
                ..clearSelectedPhotos();
            },
          ),
        ],
      );
    });
  }
}

/// 多选工具栏，当进入多选模式时出现在应用上方
// class SelectionToolBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PhotoListCubit, PhotoListState>(
//         builder: (context, state) {
//       return Container(
//         color: Color.fromARGB(220, 194, 231, 255),
//         height: 60,
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   child: Icon(Icons.close),
//                   onTap: () {
//                     context.read<PhotoListCubit>()
//                       ..setModeView()
//                       ..clearSelectedPhotos();
//                   },
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   '${state.selectedPhotos.length}',
//                   style: TextStyle(fontSize: 25),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.cloud_upload),
//                   onPressed: () {},
//                 ),
//                 SizedBox(width: 10),
//                 Icon(Icons.share),
//                 SizedBox(width: 10),
//                 Icon(Icons.delete),
//                 SizedBox(width: 10),
//                 Icon(Icons.more_vert),
//                 SizedBox(width: 10),
//               ],
//             )
//           ],
//         ),
//       );
//     });
//   }

//   _clouds() async {
//     print('uploading clouds');
//     print(Setting.userAccount);
//     var apiurl =
//         Uri.parse('http://124.223.68.12:8233/smartAlbum/uploadcloudpic.do');
//     var response = await http
//         .post(apiurl, body: {"local": "", "picOwner": "", "label": ""});

//     print('Response status : ${response.statusCode}');
//     print('Response status : ${response.body}');
//     setState(() {
//       TabsDrawer.list = jsonDecode(response.body)["data"];
//       print(TabsDrawer.list);
//     });
//   }
// }

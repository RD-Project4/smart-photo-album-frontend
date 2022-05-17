import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderCubit.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderState.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/bloc/uploadManager/UploadCubit.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
import 'package:smart_album/model/Folder.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/util/ThemeUtil.dart';
import 'package:smart_album/widgets/ThumbnailImageProvider.dart';

class SelectionToolBar extends StatefulWidget {
  final Folder? currentFolder;
  final List<Widget> Function(List<Photo>)? actionsBuilder;

  SelectionToolBar({Key? key, this.actionsBuilder, this.currentFolder})
      : super(key: key);

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
          ...widget.actionsBuilder != null
              ? widget.actionsBuilder!(state.selectedItems.toList())
              : [],
          IconButton(
              onPressed: () {
                _openFolderSelectionBottomSheet(
                    context,
                    state.selectedItems.toList(),
                    context.read<PhotoListCubit>());
              },
              icon: Icon(Icons.move_to_inbox_outlined)),
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
                showToast(
                    "Uploading in the background, please check status in the backup manager");
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

  void _openFolderSelectionBottomSheet(BuildContext context,
      List<Photo> selectedPhotoList, PhotoListCubit cubit) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BlocBuilder<CategoryFolderCubit, CategoryFolderState>(
              builder: (context, state) => Container(
                  height: 200,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: state.categoryList!
                              .map((folder) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: AspectRatio(
                                      aspectRatio: 0.76,
                                      child: Card(
                                          elevation: 6,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: InkWell(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10.0,
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      image:
                                                                          DecorationImage(
                                                                        image: ThumbnailImageProvider(folder.previewPhoto ??
                                                                            Photo.placeholder()),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ))))),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Text(
                                                        folder.name,
                                                      )),
                                                ]),
                                            onTap: () {
                                              context
                                                  .read<CategoryFolderCubit>()
                                                ..movePhotoTo(
                                                    selectedPhotoList, folder);
                                              cubit.setModeView();
                                              Navigator.pop(context);
                                            },
                                          )))))
                              .toList()))));
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

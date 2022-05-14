import 'dart:io';

// import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:recognition_qrcode/recognition_qrcode.dart';
import 'package:scan/scan.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/uploadManager/UploadCubit.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/util/DialogUtil.dart';
import 'package:smart_album/util/ThemeUtil.dart';
import 'package:smart_album/widgets/LightAppBar.dart';
import 'package:smart_album/widgets/photo/PhotoToolBar.dart';
import 'package:smart_album/widgets/photo/UrlTip.dart';
import 'package:tuple/tuple.dart';

class PhotoPage extends StatefulWidget {
  final List<Photo> photoList;
  final int initialIndex;

  PhotoPage({Key? key, required this.photoList, required this.initialIndex})
      : super(key: key);

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  // late int currentIndex = widget.initialIndex;
  late ValueNotifier<int> indexNotifier = ValueNotifier(widget.initialIndex);
  late PageController pageController;
  String? currentUrl;

  void _parseQrCode() {
    var _photo = widget.photoList[indexNotifier.value];
    Scan.parse(_photo.path).then((result) {
      if (result == null) {
        print("图中无二维码");
        return;
      }
      print("识别成功。url: $result");
      setState(() {
        currentUrl = result;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: indexNotifier.value);
    _parseQrCode();

    indexNotifier.addListener(_parseQrCode);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Photo photo = widget.photoList[indexNotifier.value];
    PhotoCubit cubit = context.read<PhotoCubit>();
    Map<String, List<Photo>> labelMap =
        cubit.getPhotoGroupedByLabel(photo.labels);
    ThemeUtil.setSystemOverlayLight(context);

    return Scaffold(
        appBar: LightAppBar(
          context,
          photo.name,
          backgroundColor: Colors.transparent,
          actions: _buildAction(context, photo),
        ),
        extendBodyBehindAppBar: true,
        body: SizedBox.expand(
            child: Stack(
          children: [
            PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.photoList.length,
                backgroundDecoration: BoxDecoration(
                  color: ThemeUtil.getBackgroundColor(context),
                ),
                pageController: pageController,
                onPageChanged: (index) => setState(() => indexNotifier.value = index)),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  FutureBuilder(
                      future: RecognitionQrcode.recognition(photo.path),
                      builder: (context, snapshot) => snapshot.data != null
                          ? UrlTip(url: (snapshot.data! as Map)['value'])
                          : Container()),
                  SizedBox(
                    height: 10,
                  ),
                  PhotoToolBar(photo: photo)
                ],
              ),
            )
          ],
        )));
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    Photo photo = widget.photoList[index];

    return PhotoViewGalleryPageOptions(
        imageProvider: photo.isLocal
            ? FileImage(File(photo.path))
            : NetworkImage(photo.path) as ImageProvider,
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 4,
        heroAttributes: PhotoViewHeroAttributes(tag: photo.id));
  }

  List<Widget> _buildAction(BuildContext context, Photo photo) {
    return [
      IconButton(
          onPressed: () {
            deleteFromLocal() {
              context.read<PhotoCubit>().movePhotoToTrashBin(photo);
              widget.photoList.remove(photo);
            }

            deleteFromCloud() {
              context.read<UploadCubit>().removePhotoFromCloud(context, photo);
            }

            refresh() {
              // However it is anti-pattern
              setState(() {
                indexNotifier.value = indexNotifier.value >= widget.photoList.length
                    ? indexNotifier.value - 1
                    : indexNotifier.value;
              });
            }

            if (photo.isLocal && photo.isCloud) {
              DialogUtil.showSelectFromListDialog(
                  context,
                  "Delete",
                  "Are you sure?",
                  Tuple2("Delete from local only", "Delete local and cloud"),
                  (i) async {
                if (i == 0) {
                  deleteFromLocal();
                } else if (i == 1) {
                  deleteFromLocal();
                  deleteFromCloud();
                }
                refresh();
                Navigator.of(context).pop();
              });
            } else if (photo.isCloud) {
              DialogUtil.showConfirmDialog(
                  context, "Delete from cloud", "Are you sure?", () {
                deleteFromCloud();
                refresh();
                Navigator.of(context).pop();
              });
            } else
              DialogUtil.showConfirmDialog(context, "Delete",
                  "The photo will be move to the trash bin.\nAre you sure?",
                  () {
                deleteFromLocal();
                refresh();
                Navigator.of(context).pop();
              });
          },
          icon: Icon(Icons.delete_outline_outlined))
    ];
  }

  // Widget _buildLabelBar(Map<String, List<Photo>> labelMap) {
  //   return Row(
  //       children: labelMap.entries
  //           .map<Widget>((entries) => Padding(
  //               padding: EdgeInsets.all(10),
  //               child: Container(
  //                   width: 100,
  //                   child: Card(
  //                     clipBehavior: Clip.antiAliasWithSaveLayer,
  //                     child: InkWell(
  //                         child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                           Expanded(
  //                             child: Container(
  //                                 decoration: BoxDecoration(
  //                                     image: DecorationImage(
  //                                         fit: BoxFit.cover,
  //                                         image: entries.value[0].isLocal
  //                                             ? FileImage(
  //                                                 File(entries.value[0].path))
  //                                             : NetworkImage(
  //                                                     entries.value[0].path)
  //                                                 as ImageProvider))),
  //                           ),
  //                           Padding(
  //                               padding: EdgeInsets.symmetric(vertical: 5),
  //                               child: Text(CommonUtil.capitalizeFirstLetter(
  //                                   entries.key))),
  //                         ])),
  //                   ))))
  //           .toList());
  // }
}

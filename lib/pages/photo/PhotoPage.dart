import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/util/CommonUtil.dart';
import 'package:smart_album/util/ThemeUtil.dart';
import 'package:smart_album/widgets/LightAppBar.dart';

class PhotoPage extends StatefulWidget {
  final List<Photo> photoList;
  final int initialIndex;

  PhotoPage({Key? key, required this.photoList, required this.initialIndex})
      : super(key: key);

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late int currentIndex = widget.initialIndex;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    Photo photo = widget.photoList[currentIndex];
    PhotoCubit cubit = context.read<PhotoCubit>();
    Map<String, List<Photo>> labelMap =
        cubit.getPhotoGroupedByLabel(photo.labels);

    return Scaffold(
        appBar: LightAppBar(
          context,
          photo.name,
          actions: [_buildPopupMenu()],
        ),
        body: SizedBox.expand(
            child: Column(
          children: [
            Expanded(
                child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.photoList.length,
              backgroundDecoration: BoxDecoration(
                color: ThemeUtil.getBackgroundColor(context),
              ),
              pageController: pageController,
              onPageChanged: (index) => setState(() => currentIndex = index),
            )),
            SizedBox(
              height: 160,
              child: Row(
                  children: labelMap.entries
                      .map<Widget>((entries) => Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                              width: 100,
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: InkWell(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                      Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: photo.isLocal
                                                        ? FileImage(File(entries
                                                            .value[0].path))
                                                        : NetworkImage(
                                                                photo.path)
                                                            as ImageProvider))),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                              CommonUtil.capitalizeFirstLetter(
                                                  entries.key))),
                                    ])),
                              ))))
                      .toList()),
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
      heroAttributes: PhotoViewHeroAttributes(tag: photo.id),
    );
  }

  PopupMenuButton _buildPopupMenu() {
    return PopupMenuButton(
        itemBuilder: (context) => [
              _buildPopupMenuItem(() {}, Icons.share, "Share",
                  iconColor: Colors.green),
              _buildPopupMenuItem(() {}, Icons.cloud_upload, "Upload",
                  iconColor: Colors.lightBlue),
              _buildPopupMenuItem(() {}, Icons.favorite, "Favorite",
                  iconColor: Colors.red),
              _buildPopupMenuItem(() {}, Icons.palette, "Palette",
                  iconColor: Colors.amber),
              _buildPopupMenuItem(() {}, Icons.delete, "Delete",
                  iconColor: Colors.grey),
            ]);
  }

  PopupMenuItem _buildPopupMenuItem(onTap, IconData icon, String text,
      {Color? iconColor}) {
    return PopupMenuItem(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,color: iconColor ?? Colors.black,),
            SizedBox(
              width: 10,
            ),
            Text(text)
          ],
        ));
  }
}

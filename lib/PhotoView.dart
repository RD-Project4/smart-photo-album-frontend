import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smart_album/widgets/PhotoToolBar.dart';

class PhotoView<T> extends StatefulWidget {
  final ImageProvider Function(T item) imageBuilder;
  final Widget Function(T item)? descBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<T> galleryItems;
  final Axis scrollDirection;

  PhotoView({
    required this.imageBuilder,
    this.descBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : this.pageController = PageController(initialPage: initialIndex);

  @override
  State<StatefulWidget> createState() => _PhotoViewState<T>();
}

class _PhotoViewState<T> extends State<PhotoView<T>> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${currentIndex + 1} of ${widget.galleryItems.length}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  widget.descBuilder != null
                      ? widget.descBuilder!(widget.galleryItems[currentIndex])
                      : Container(),
                  PhotoToolBar(photo: widget.galleryItems[currentIndex])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    var item = widget.galleryItems[index];

    return PhotoViewGalleryPageOptions(
      imageProvider: widget.imageBuilder(item),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 4,
      heroAttributes: PhotoViewHeroAttributes(tag: item.hashCode),
    );
  }
}

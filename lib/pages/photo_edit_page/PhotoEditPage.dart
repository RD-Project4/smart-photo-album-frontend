import 'dart:io';
import 'dart:typed_data';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/Events.dart';
import 'package:smart_album/util/Global.dart';
import 'package:group_button/group_button.dart';
import 'package:smart_album/widgets/filter/FilterSelector.dart';
import 'dart:ui' as ui;

class PhotoEditPage extends StatefulWidget {
  final AssetEntity entity;

  const PhotoEditPage({Key? key, required this.entity}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoEditPage();
}

class _PhotoEditPage extends State<PhotoEditPage> {
  final GlobalKey rootWidgetKey = GlobalKey();
  bool ableToSave = false;

  @override
  Widget build(BuildContext context) {
    final _filters = [
      Colors.white,
      ...List.generate(
        Colors.primaries.length,
        (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
      )
    ];
    final _filterColor = ValueNotifier<Color>(Colors.white);
    void _onFilterChanged(Color value) {
      _filterColor.value = value;
    }

    // 返回带滤镜的照片
    Widget _buildPhotoWithFilter() {
      return ValueListenableBuilder(
        valueListenable: _filterColor,
        builder: (context, value, child) {
          final color = value as Color;
          final file = File(
              '${Global.ROOT_PATH}${widget.entity.relativePath}${widget.entity.title}');
          // 包裹RepaintBoundary用于截图组件
          return RepaintBoundary(
              key: rootWidgetKey,
              child: Image.file(
                file,
                color: color.withOpacity(0.5),
                colorBlendMode: BlendMode.color,
                fit: BoxFit.cover,
              ));
        },
      );
    }

    // 保存组件截图
    Future<void> saveEditing() async {
      RenderRepaintBoundary boundary = rootWidgetKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(pngBytes!);
      if(result != null){
        showToast('Image saved');
      }


      Global.eventBus.fire(ReloadPhotosEvent());
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Center(child: _buildPhotoWithFilter()),
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
                buttons: ['Filter', 'Adjust', 'Markup'],
                onSelected: (index, isSelected) =>
                    debugPrint('Button $index selected'),
                controller: GroupButtonController(
                  selectedIndex: 0, // 默认选中
                ),
                options: GroupButtonOptions(
                  borderRadius: BorderRadius.circular(1000),
                  selectedColor: Color.fromARGB(255, 68, 71, 70),
                  selectedTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color.fromARGB(255, 227, 227, 227),
                  ),
                  unselectedColor: Colors.black,
                  unselectedTextStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color.fromARGB(255, 117, 117, 117),
                  ),
                ),
              ),
              FilterSelector(
                  filters: _filters, onFilterChanged: _onFilterChanged),
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
                      onPressed: saveEditing,
                      child: Text(
                        'Save',
                        // style: TextStyle(
                        //     color: ableToSave ? Colors.white : Colors.grey),
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

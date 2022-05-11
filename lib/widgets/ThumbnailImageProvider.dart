import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:quiver/cache.dart';
import 'package:smart_album/database/Photo.dart';

class ThumbnailImageProvider extends ImageProvider<ThumbnailImageProvider> {
  static MapCache lruMap = MapCache.lru(maximumSize: 30);

  final Photo photo;
  final double scale;

  const ThumbnailImageProvider(this.photo, {this.scale = 1.0});

  @override
  ImageStreamCompleter load(
      ThumbnailImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: scale,
      debugLabel: photo.path,
      informationCollector: () => <DiagnosticsNode>[
        ErrorDescription('Path: ${photo.path}'),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
      ThumbnailImageProvider key, DecoderCallback decode) async {
    var cache = await lruMap.get(photo.entity_id);
    if (cache != null) return decode(cache);

    final assetEntity = await AssetEntity.fromId(photo.entity_id);
    var data = await assetEntity?.thumbnailDataWithOption(
      ThumbnailOption(size: ThumbnailSize.square(250)),
    );
    if (data == null) {
      // The file may become available later.
      PaintingBinding.instance!.imageCache!.evict(key);
      throw StateError(
          '${photo.path} is empty and cannot be loaded as an image.');
    } else
      lruMap.set(photo.entity_id, data);
    return decode(data);
  }

  @override
  Future<ThumbnailImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ThumbnailImageProvider>(this);
  }
}

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:quiver/cache.dart';
import 'package:smart_album/model/Photo.dart';

class ThumbnailImageProvider extends ImageProvider<ThumbnailImageProvider> {
  NetworkImage? networkProvider;

  static MapCache lruMap = MapCache.lru(maximumSize: 30);

  final Photo photo;
  final double scale;

  ThumbnailImageProvider(this.photo, {this.scale = 1.0});

  @override
  ImageStreamCompleter load(
      ThumbnailImageProvider key, DecoderCallback decode) {
    if (!photo.isLocal && photo.isCloud) {
      if (networkProvider == null)
        networkProvider = NetworkImage(photo.thumbnailPath!);
      return networkProvider!.load(networkProvider!, decode);
    }
    return MultiFrameImageStreamCompleter(
      codec: _loadFromFile(key, decode),
      scale: scale,
      debugLabel: photo.path,
      informationCollector: () => <DiagnosticsNode>[
        ErrorDescription('Path: ${photo.path}'),
      ],
    );
  }

  Future<ui.Codec> _loadFromFile(
      ThumbnailImageProvider key, DecoderCallback decode) async {
    var cache = await lruMap.get(photo.entityId);
    if (cache != null) return cache;

    var data;
    if (photo.isLocal) {
      final assetEntity = await AssetEntity.fromId(photo.entityId!);
      data = await assetEntity?.thumbnailDataWithOption(
        ThumbnailOption(size: ThumbnailSize.square(250)),
      );
    }

    if (data == null) {
      // The file may become available later.
      PaintingBinding.instance!.imageCache!.evict(key);
      throw StateError(
          '${photo.path} is empty and cannot be loaded as an image.');
    } else {
      var codec = await decode(data);
      lruMap.set(photo.entityId, codec);
      return codec;
    }
  }

  @override
  Future<ThumbnailImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ThumbnailImageProvider>(this);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is ThumbnailImageProvider &&
        other.photo.id == photo.id &&
        other.scale == scale;
  }

  @override
  int get hashCode => hashValues(photo.entityId, scale);
}

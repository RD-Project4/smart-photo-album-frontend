// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'model/Category.dart';
import 'model/HIstory.dart';
import 'model/Photo.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 8452154140893309457),
      name: 'Photo',
      lastPropertyId: const IdUid(19, 8794456690119365015),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 989340443064075646),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3203715375406232874),
            name: 'path',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6720509377879332907),
            name: 'labels',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4721466364384475782),
            name: 'width',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1092866033635600321),
            name: 'height',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 3836911989879182796),
            name: 'creationDateTime',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 5928449047530009145),
            name: 'location',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 5697620779040010095),
            name: 'entityId',
            type: 9,
            flags: 2048,
            indexId: const IdUid(3, 4633289790922245848)),
        ModelProperty(
            id: const IdUid(13, 7496462533197211908),
            name: 'cloudId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 4207547672681910534),
            name: 'thumbnailPath',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 419747438367326722),
            name: 'isCloud',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 7508849960037728736),
            name: 'isLocal',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 7651469783806390219),
            name: 'isFavorite',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 810372771465484196),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(19, 8794456690119365015),
            name: 'isDeleted',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 6472757513092641637),
      name: 'History',
      lastPropertyId: const IdUid(2, 3043731862009199497),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7579540795106331461),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3043731862009199497),
            name: 'name',
            type: 9,
            flags: 2048,
            indexId: const IdUid(2, 3877532730341886472))
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 4139173113446546881),
      name: 'Category',
      lastPropertyId: const IdUid(6, 2943526286783902201),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2364032299298431250),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7040229653329637807),
            name: 'name',
            type: 9,
            flags: 2048,
            indexId: const IdUid(4, 4839437694175533174)),
        ModelProperty(
            id: const IdUid(3, 3869856611413703840),
            name: 'labelList',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4441611100883772125),
            name: 'locationList',
            type: 30,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(3, 4139173113446546881),
      lastIndexId: const IdUid(4, 4839437694175533174),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [7713753588704185151],
      retiredPropertyUids: const [
        5711374106246872086,
        5826839999700844135,
        4775042554793791797,
        3168296054505618822,
        427707142129404978,
        2943526286783902201
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Photo: EntityDefinition<Photo>(
        model: _entities[0],
        toOneRelations: (Photo object) => [],
        toManyRelations: (Photo object) => {},
        getId: (Photo object) => object.id,
        setId: (Photo object, int id) {
          object.id = id;
        },
        objectToFB: (Photo object, fb.Builder fbb) {
          final pathOffset = fbb.writeString(object.path);
          final labelsOffset = fbb.writeList(
              object.labels.map(fbb.writeString).toList(growable: false));
          final locationOffset = object.location == null
              ? null
              : fbb.writeString(object.location!);
          final entityIdOffset = object.entityId == null
              ? null
              : fbb.writeString(object.entityId!);
          final cloudIdOffset =
              object.cloudId == null ? null : fbb.writeString(object.cloudId!);
          final thumbnailPathOffset = object.thumbnailPath == null
              ? null
              : fbb.writeString(object.thumbnailPath!);
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(20);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, pathOffset);
          fbb.addOffset(2, labelsOffset);
          fbb.addInt64(4, object.width);
          fbb.addInt64(5, object.height);
          fbb.addInt64(9, object.creationDateTime.millisecondsSinceEpoch);
          fbb.addOffset(10, locationOffset);
          fbb.addOffset(11, entityIdOffset);
          fbb.addOffset(12, cloudIdOffset);
          fbb.addOffset(13, thumbnailPathOffset);
          fbb.addBool(14, object.isCloud);
          fbb.addBool(15, object.isLocal);
          fbb.addBool(16, object.isFavorite);
          fbb.addOffset(17, nameOffset);
          fbb.addBool(18, object.isDeleted);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Photo(
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 26),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 38, ''),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              const fb.ListReader<String>(
                      fb.StringReader(asciiOptimization: true),
                      lazy: false)
                  .vTableGet(buffer, rootOffset, 8, []),
              DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0)),
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0),
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 24),
              const fb.BoolReader().vTableGet(buffer, rootOffset, 32, false),
              const fb.BoolReader().vTableGet(buffer, rootOffset, 34, false))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..cloudId = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 28)
            ..thumbnailPath = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 30)
            ..isFavorite =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 36, false)
            ..isDeleted =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 40, false);

          return object;
        }),
    History: EntityDefinition<History>(
        model: _entities[1],
        toOneRelations: (History object) => [],
        toManyRelations: (History object) => {},
        getId: (History object) => object.id,
        setId: (History object, int id) {
          object.id = id;
        },
        objectToFB: (History object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = History(const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, ''))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    Category: EntityDefinition<Category>(
        model: _entities[2],
        toOneRelations: (Category object) => [],
        toManyRelations: (Category object) => {},
        getId: (Category object) => object.id,
        setId: (Category object, int id) {
          object.id = id;
        },
        objectToFB: (Category object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final labelListOffset = fbb.writeList(
              object.labelList.map(fbb.writeString).toList(growable: false));
          final locationListOffset = object.locationList == null
              ? null
              : fbb.writeList(object.locationList!
                  .map(fbb.writeString)
                  .toList(growable: false));
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, labelListOffset);
          fbb.addOffset(3, locationListOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Category(
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              const fb.ListReader<String>(
                      fb.StringReader(asciiOptimization: true),
                      lazy: false)
                  .vTableGet(buffer, rootOffset, 8, []),
              const fb.ListReader<String>(
                      fb.StringReader(asciiOptimization: true),
                      lazy: false)
                  .vTableGetNullable(buffer, rootOffset, 10))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Photo] entity fields to define ObjectBox queries.
class Photo_ {
  /// see [Photo.id]
  static final id = QueryIntegerProperty<Photo>(_entities[0].properties[0]);

  /// see [Photo.path]
  static final path = QueryStringProperty<Photo>(_entities[0].properties[1]);

  /// see [Photo.labels]
  static final labels =
      QueryStringVectorProperty<Photo>(_entities[0].properties[2]);

  /// see [Photo.width]
  static final width = QueryIntegerProperty<Photo>(_entities[0].properties[3]);

  /// see [Photo.height]
  static final height = QueryIntegerProperty<Photo>(_entities[0].properties[4]);

  /// see [Photo.creationDateTime]
  static final creationDateTime =
      QueryIntegerProperty<Photo>(_entities[0].properties[5]);

  /// see [Photo.location]
  static final location =
      QueryStringProperty<Photo>(_entities[0].properties[6]);

  /// see [Photo.entityId]
  static final entityId =
      QueryStringProperty<Photo>(_entities[0].properties[7]);

  /// see [Photo.cloudId]
  static final cloudId = QueryStringProperty<Photo>(_entities[0].properties[8]);

  /// see [Photo.thumbnailPath]
  static final thumbnailPath =
      QueryStringProperty<Photo>(_entities[0].properties[9]);

  /// see [Photo.isCloud]
  static final isCloud =
      QueryBooleanProperty<Photo>(_entities[0].properties[10]);

  /// see [Photo.isLocal]
  static final isLocal =
      QueryBooleanProperty<Photo>(_entities[0].properties[11]);

  /// see [Photo.isFavorite]
  static final isFavorite =
      QueryBooleanProperty<Photo>(_entities[0].properties[12]);

  /// see [Photo.name]
  static final name = QueryStringProperty<Photo>(_entities[0].properties[13]);

  /// see [Photo.isDeleted]
  static final isDeleted =
      QueryBooleanProperty<Photo>(_entities[0].properties[14]);
}

/// [History] entity fields to define ObjectBox queries.
class History_ {
  /// see [History.id]
  static final id = QueryIntegerProperty<History>(_entities[1].properties[0]);

  /// see [History.name]
  static final name = QueryStringProperty<History>(_entities[1].properties[1]);
}

/// [Category] entity fields to define ObjectBox queries.
class Category_ {
  /// see [Category.id]
  static final id = QueryIntegerProperty<Category>(_entities[2].properties[0]);

  /// see [Category.name]
  static final name = QueryStringProperty<Category>(_entities[2].properties[1]);

  /// see [Category.labelList]
  static final labelList =
      QueryStringVectorProperty<Category>(_entities[2].properties[2]);

  /// see [Category.locationList]
  static final locationList =
      QueryStringVectorProperty<Category>(_entities[2].properties[3]);
}

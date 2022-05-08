import 'package:smart_album/widgets/QueryStreamBuilder.dart';

import '../objectbox.g.dart';
import 'Photo.dart';

class ObjectStore {
  late final Store _store;

  late final Box<Photo> _photoBox;

  late final QueryStream<Photo> _allPhotoStream;

  ObjectStore._create(this._store) {
    this._photoBox = _store.box<Photo>();
    _allPhotoStream = QueryStream(this._store, _photoBox.query());
  }

  static Future<ObjectStore> create() async {
    final _store = await openStore();
    _instance = ObjectStore._create(_store);
    return _instance!;
  }

  static ObjectStore? _instance;

  static ObjectStore get() {
    return _instance!;
  }

  getPhoto() {
    return _photoBox.getAll();
  }

  QueryStream<Photo> getPhotoStream() {
    return _allPhotoStream;
  }

  storePhoto(List<Photo> photoList) {
    _photoBox.putMany(photoList);
  }

  removePhoto(List<int> photoIdList) {
    _photoBox.removeMany(photoIdList);
  }
}

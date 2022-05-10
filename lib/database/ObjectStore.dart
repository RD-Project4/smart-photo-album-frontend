import 'package:smart_album/widgets/QueryStreamBuilder.dart';
import 'package:tuple/tuple.dart';

import '../objectbox.g.dart';
import 'Photo.dart';

class EmptyCondition<T> implements Condition<T> {
  @override
  Condition<T> operator &(Condition<T> rh) {
    return rh;
  }

  @override
  Condition<T> and(Condition<T> rh) {
    return rh;
  }

  @override
  Condition<T> andAll(List<Condition<T>> rh) {
    throw UnimplementedError();
  }

  @override
  Condition<T> or(Condition<T> rh) {
    return rh;
  }

  @override
  Condition<T> orAny(List<Condition<T>> rh) {
    throw UnimplementedError();
  }

  @override
  Condition<T> operator |(Condition<T> rh) {
    return rh;
  }
}

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

  List<Photo> getPhoto() {
    return _photoBox.getAll();
  }

  List<Photo> getPhotoBy(
      {List<String>? labelList, Tuple2<DateTime, DateTime>? range}) {
    Condition<Photo> condition = EmptyCondition();
    if (labelList != null && labelList.isNotEmpty) {
      for (var label in labelList) {
        condition = condition.or(Photo_.labels.contains(label));
      }
    }

    if (range != null)
      condition = condition.and(Photo_.creationDateTime.between(
          range.item1.millisecondsSinceEpoch,
          range.item2.millisecondsSinceEpoch));

    return _photoBox.query(condition).build().find();
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

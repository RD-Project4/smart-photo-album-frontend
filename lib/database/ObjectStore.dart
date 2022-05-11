import 'package:smart_album/database/HIstory.dart';
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
  late final Box<History> _historyBox;

  late final QueryStream<Photo> _allPhotoStream;
  late final QueryStream<History> _allHistoryStream;

  ObjectStore._create(this._store) {
    this._photoBox = _store.box<Photo>();
    this._historyBox = _store.box<History>();
    _allPhotoStream = QueryStream(this._store, _photoBox.query());
    _allHistoryStream = QueryStream(this._store, _historyBox.query());
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

  getHistoryStream() {
    return _allHistoryStream;
  }

  addHistory(History history) {
    num count = _historyBox.count();
    if (count > 8) {
      var builder = _historyBox.query()..order(History_.id);
      var first = builder.build().findFirst();
      if (first != null) _historyBox.remove(first.id);
    }
    _historyBox.put(history);
  }
}

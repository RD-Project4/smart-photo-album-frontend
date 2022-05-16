import 'package:smart_album/model/Category.dart';
import 'package:smart_album/model/HIstory.dart';
import 'package:tuple/tuple.dart';

import '../model/Photo.dart';
import '../objectbox.g.dart';

// `flutter pub run build_runner build` to refresh the *.g.dart once any pojo class is changed.

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
  late final Box<Category> _categoryBox;

  ObjectStore._create(this._store) {
    this._photoBox = _store.box<Photo>();
    this._historyBox = _store.box<History>();
    this._categoryBox = _store.box<Category>();
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

  List<Photo> getPhotoBy(
      {List<String>? labelList,
      Tuple2<DateTime, DateTime>? dateRange,
      List<String>? locationList}) {
    Condition<Photo> condition = EmptyCondition();
    if (labelList != null && labelList.isNotEmpty) {
      Condition<Photo> labelCondition = EmptyCondition();
      for (var label in labelList) {
        labelCondition = labelCondition.or(Photo_.labels.contains(label));
      }
      condition = condition.and(labelCondition);
    }

    if (dateRange != null)
      condition = condition.and(Photo_.creationDateTime.between(
          dateRange.item1.millisecondsSinceEpoch,
          dateRange.item2.millisecondsSinceEpoch));

    if (locationList != null && locationList.isNotEmpty) {
      Condition<Photo> locationCondition = EmptyCondition();
      for (var location in locationList)
        locationCondition =
            locationCondition.or(Photo_.location.equals(location));
      condition = condition.and(locationCondition);
    }

    if (condition is EmptyCondition) return _photoBox.getAll();
    return _photoBox.query(condition).build().find();
  }

  List<Photo> getPhotoList() {
    return _photoBox.getAll();
  }

  Stream<List<Photo>> getPhotoStream() {
    return _photoBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  clearAndStorePhotoList(List<Photo> photoList) {
    _photoBox.removeAll();
    _photoBox.putMany(photoList);
  }

  storePhotoList(List<Photo> photoList) {
    _photoBox.putMany(photoList);
  }

  storePhoto(Photo photo) {
    _photoBox.put(photo);
  }

  removePhotoList(List<int> photoIdList) {
    _photoBox.removeMany(photoIdList);
  }

  Stream<List<History>> getHistoryStream() {
    return _historyBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
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

  List<String> getAllCities() {
    var query = _photoBox.query().build();
    PropertyQuery<String> pq = query.property(Photo_.location);
    pq.distinct = true;
    return pq.find().where((city) => city.isNotEmpty).toList();
  }

  Stream<List<Category>> getCategoryStream() {
    return _categoryBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  addCategory(Category category) {
    _categoryBox.put(category);
  }

  removeCategoryList(List<Category> category) {
    _categoryBox.removeMany(category.map((e) => e.id).toList());
  }
}

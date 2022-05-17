import 'package:objectbox/objectbox.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:tuple/tuple.dart';

@Entity()
class Folder {
  @Id()
  int id = 0;
  @Index()
  String name;
  List<String> labelList;
  Tuple2<DateTime, DateTime>? dateRange;
  List<String>? locationList;
  ToMany<Photo> includeList = ToMany<Photo>();
  ToMany<Photo> excludeList = ToMany<Photo>();
  Photo? previewPhoto;

  Folder(this.name, this.labelList, this.locationList,
      {List<DateTime>? range, Tuple2<DateTime, DateTime>? rangeTuple}) {
    if (range != null)
      this.dbDateRange = range;
    else if (rangeTuple != null) this.dateRange = rangeTuple;
  }

  List<DateTime>? get dbDateRange {
    if (dateRange == null) return null;
    return [dateRange!.item1, dateRange!.item2];
  }

  set dbDateRange(List<DateTime>? range) {
    if (range == null) dateRange = null;
    dateRange = Tuple2(range![0], range[1]);
  }
}

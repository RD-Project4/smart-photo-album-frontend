import 'package:smart_album/database/Photo.dart';
import 'package:tuple/tuple.dart';

class SearchState {
  String text = "";
  List<String> labelList = [];
  Tuple2<DateTime, DateTime>? dateRange;
  List<String> locationList = [];

  // Null 代表还未搜索
  List<Photo>? searchResult;

  SearchState clone() {
    return SearchState()
      ..text = text
      ..labelList = labelList
      ..dateRange = dateRange
      ..locationList = locationList;
  }
}

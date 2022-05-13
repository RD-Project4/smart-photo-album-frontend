import 'package:smart_album/model/HIstory.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:tuple/tuple.dart';

class SearchState {
  String text = "";
  List<String> labelList = [];
  Tuple2<DateTime, DateTime>? dateRange;
  List<String> locationList = [];

  // Null 代表还未搜索
  List<Photo>? searchResult;

  List<History>? historyList = [];

  SearchState clone() {
    return SearchState()
      ..text = text
      ..labelList = labelList
      ..dateRange = dateRange
      ..locationList = locationList
      ..searchResult = searchResult
      ..historyList = historyList;
  }
}

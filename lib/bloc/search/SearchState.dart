import 'package:smart_album/model/HIstory.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:tuple/tuple.dart';

enum GroupByOption { CREATE_TIME, LABEL, LOCATION, IMAGE_SIZE }

class SearchState {
  String text = "";
  List<String> labelList = [];
  Tuple2<DateTime, DateTime>? dateRange;
  List<String> locationList = [];

  GroupByOption groupBy = GroupByOption.CREATE_TIME;

  // Null 代表还未搜索
  List<Photo>? searchResult;

  List<History>? historyList = [];

  SearchState clone() {
    return SearchState()
      ..text = text
      ..labelList = labelList
      ..dateRange = dateRange
      ..locationList = locationList
      ..groupBy = groupBy
      ..searchResult = searchResult
      ..historyList = historyList;
  }
}

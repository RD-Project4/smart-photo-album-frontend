import 'package:smart_album/database/Photo.dart';

class SearchState {
  String text = "";
  List<String> labelList = [];

  // Null 代表还未搜索
  List<Photo>? searchResult;

  SearchState clone() {
    return SearchState()
      ..text = text
      ..labelList = labelList;
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/database/HIstory.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';

import 'SearchState.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState());

  setText(text) => state.text = text;

  setLabelList(labelList) => state.labelList = labelList;

  containsLabel(label) => state.labelList.contains(label);

  setDateRange(range) => state.dateRange = range;

  hasSearchResult() => state.searchResult != null;

  clearSearchResult() => emit(state.clone()..searchResult = null);

  search() {
    if (state.text.isNotEmpty)
      ObjectStore.get().addHistory(History(state.text));
    var photoList = ObjectStore.get()
        .getPhotoBy(labelList: state.labelList, range: state.dateRange);
    emit(state.clone()..searchResult = photoList);
  }

  QueryStream<History> getHistory() {
    return ObjectStore.get().getHistoryStream();
  }
}

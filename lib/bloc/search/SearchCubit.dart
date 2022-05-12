import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/HIstory.dart';

import 'SearchState.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState()) {
    ObjectStore.get().getHistoryStream().listen((list) {
      emit(state.clone()..historyList = list);
    });
  }

  setText(text) => state.text = text;

  setLabelList(labelList) => state.labelList = labelList;

  containsLabel(label) => state.labelList.contains(label);

  setDateRange(range) => state.dateRange = range;

  setLocationList(List<String> locationList) =>
      state.locationList = locationList;

  setGroupBy(GroupByOption groupBy) => emit(state.clone()..groupBy = groupBy);

  hasSearchResult() => state.searchResult != null;

  clearSearchResult() => emit(state.clone()..searchResult = null);

  clearSearchQuery() => emit(SearchState()..historyList = state.historyList);

  search() {
    if (state.text.isNotEmpty)
      ObjectStore.get().addHistory(History(state.text));
    var photoList = ObjectStore.get().getPhotoBy(
        labelList: state.labelList,
        dateRange: state.dateRange,
        locationList: state.locationList);
    emit(state.clone()..searchResult = photoList);
  }

  List<String> getCities() {
    return ObjectStore.get().getAllCities();
  }
}

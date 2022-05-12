import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/model/HIstory.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';

import 'SearchState.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState());

  setText(text) => state.text = text;

  setLabelList(labelList) => state.labelList = labelList;

  containsLabel(label) => state.labelList.contains(label);

  setDateRange(range) => state.dateRange = range;

  setLocationList(List<String> locationList) =>
      state.locationList = locationList;

  setGroupBy(GroupByOption groupBy) => emit(state..groupBy = groupBy);

  hasSearchResult() => state.searchResult != null;

  clearSearchResult() => emit(state.clone()..searchResult = null);

  clearSearchQuery() => emit(SearchState());

  search() {
    if (state.text.isNotEmpty)
      ObjectStore.get().addHistory(History(state.text));
    var photoList = ObjectStore.get().getPhotoBy(
        labelList: state.labelList,
        range: state.dateRange,
        locationList: state.locationList);
    emit(state.clone()..searchResult = photoList);
  }

  QueryStream<History> getHistory() {
    return ObjectStore.get().getHistoryStream();
  }

  List<String> getCities() {
    return ObjectStore.get().getAllCities();
  }
}

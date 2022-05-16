import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/HIstory.dart';

import 'SearchState.dart';

class SearchCubit extends Cubit<SearchState> {
  late StreamSubscription subscription;

  SearchCubit() : super(SearchState()) {
    subscription = ObjectStore.get().getHistoryStream().listen((list) {
      emit(state.clone()..historyList = list);
    });
  }

  @override
  Future<void> close() async {
    super.close();
    subscription.cancel();
  }

  setText(text) => state.text = text;

  setLabelList(labelList) => state.labelList = labelList;

  containsLabel(label) => state.labelList.contains(label);

  setDateRange(range) => state.dateRange = range;

  setLocationList(List<String> locationList) =>
      state.locationList = locationList;

  hasSearchResult() => state.searchResult != null;

  clearSearchResult() => emit(state.clone()..searchResult = null);

  clearSearchQuery() => emit(SearchState()..historyList = state.historyList);

  search() {
    if (state.labelList.length > 0)
      ObjectStore.get().addHistory(History(state.labelList[0]));
    var photoList = ObjectStore.get().getPhotoBy(
        text: state.text.isNotEmpty ? state.text : null,
        labelList: state.labelList,
        dateRange: state.dateRange,
        locationList: state.locationList);
    emit(state.clone()..searchResult = photoList);
  }

  List<String> getCities() {
    return ObjectStore.get().getAllCities();
  }
}

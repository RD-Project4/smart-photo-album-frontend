import 'package:flutter_bloc/flutter_bloc.dart';

import 'SearchState.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState());

  setText(text) => state.text = text;

  setLabelList(labelList) => state.labelList = labelList;

  containsLabel(label) => state.labelList.contains(label);

  search() {}
}

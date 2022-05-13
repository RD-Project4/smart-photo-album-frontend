import 'package:flutter_bloc/flutter_bloc.dart';

enum ListMode { View, Selection }

abstract class SelectableListState<T> {
  ListMode mode = ListMode.View;
  Set<T> selectedItems = Set();

  clone() {
    return subClassClone()
      ..mode = mode
      ..selectedItems = selectedItems;
  }

  SelectableListState<T> subClassClone();
}

class SelectableListCubit<T extends SelectableListState<U>, U>
    extends Cubit<T> {
  SelectableListCubit(T initialState) : super(initialState);

  void setModeView() => emit(state.clone()
    ..selectedItems = Set<U>()
    ..mode = ListMode.View);

  void setModeSelection() => emit(state.clone()..mode = ListMode.Selection);

  void addSelectedItem(U item) {
    var list = state.selectedItems;
    list.add(item);
    emit(state.clone()..selectedItems = list);
  }

  void removeSelectedItem(U item) {
    var list = state.selectedItems;
    list.remove(item);
    emit(state.clone()..selectedItems = list);
  }

  void addOrRemoveSelectedItem(U item) {
    if (state.selectedItems.contains(item))
      removeSelectedItem(item);
    else
      addSelectedItem(item);
  }

  void clearSelectedItems() {
    emit(state.clone()..selectedItems = Set<U>());
  }
}

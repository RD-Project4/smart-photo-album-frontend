import 'dart:async';

import 'package:smart_album/bloc/SelectableList/SelectableListCubit.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderState.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/Category.dart';

class CategoryFolderCubit
    extends SelectableListCubit<CategoryFolderState, Category> {
  late StreamSubscription subscription;

  CategoryFolderCubit() : super(CategoryFolderState()) {
    ObjectStore.get().getCategoryStream().listen((list) {
      emit(state.clone()..categoryList = list);
    });
  }

  @override
  Future<void> close() async {
    super.close();
    subscription.cancel();
  }

  void removeSelectedCategory() {
    ObjectStore.get().removeCategoryList(state.selectedItems.toList());
    setModeView();
  }
}

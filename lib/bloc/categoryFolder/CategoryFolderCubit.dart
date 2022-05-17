import 'dart:async';

import 'package:smart_album/bloc/SelectableList/SelectableListCubit.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderState.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/Folder.dart';
import 'package:smart_album/model/Photo.dart';

class CategoryFolderCubit
    extends SelectableListCubit<CategoryFolderState, Folder> {
  late StreamSubscription subscription;

  CategoryFolderCubit() : super(CategoryFolderState()) {
    subscription = ObjectStore.get().getCategoryStream().listen((list) {
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
  }

  void removePhotoFromFolder(List<Photo> photoList, Folder folder) {
    photoList.forEach((photo) => folder.includeList.remove(photo));
    folder.excludeList.addAll(photoList);
    ObjectStore.get().storeCategory(folder);
  }

  void movePhotoTo(List<Photo> photoList, Folder folder) {
    photoList.forEach((photo) => folder.excludeList.remove(photo));
    folder.includeList.addAll(photoList);
    ObjectStore.get().storeCategory(folder);
  }
}

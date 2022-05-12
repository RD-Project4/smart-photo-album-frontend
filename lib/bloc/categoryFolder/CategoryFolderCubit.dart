import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderState.dart';
import 'package:smart_album/database/ObjectStore.dart';

class CategoryFolderCubit extends Cubit<CategoryFolderState> {
  CategoryFolderCubit() : super(CategoryFolderState()) {
    ObjectStore.get().getCategoryStream().listen((list) {
      emit(state.clone()..categoryList = list);
    });
  }
}

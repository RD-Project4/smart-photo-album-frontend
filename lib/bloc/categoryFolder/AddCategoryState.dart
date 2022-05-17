import 'package:smart_album/bloc/search/SearchCubit.dart';
import 'package:smart_album/bloc/search/SearchState.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/Folder.dart';

class AddCategoryCubit extends SearchCubit {
  AddCategoryCubit() : super();

  setName(String value) {
    state.text = value;
  }

  addCategory() {
    ObjectStore.get().storeCategory(Folder(
        state.text, state.labelList, state.locationList,
        rangeTuple: state.dateRange));
    emit(SearchState());
  }
}

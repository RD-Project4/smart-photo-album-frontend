import 'package:smart_album/bloc/search/SearchCubit.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/Category.dart';

class AddCategoryCubit extends SearchCubit {
  AddCategoryCubit() : super();

  setName(String value) {
    state.text = value;
  }

  addCategory() {
    ObjectStore.get().addCategory(Category(
        state.text, state.labelList, state.locationList,
        rangeTuple: state.dateRange));
  }
}

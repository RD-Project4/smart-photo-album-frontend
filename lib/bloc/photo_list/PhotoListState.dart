part of 'PhotoListCubit.dart';

enum GroupByOption { CREATE_TIME, LABEL, LOCATION, IMAGE_SIZE }

class PhotoListState extends SelectableListState<Photo> {
  GroupByOption groupBy = GroupByOption.CREATE_TIME;

  @override
  SelectableListState<Photo> subClassClone() {
    return PhotoListState()..groupBy = groupBy;
  }
}

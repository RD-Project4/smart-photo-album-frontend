import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/model/UserInfo.dart';

import 'UserState.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());

  void changeUser(UserInfo user) {
    emit(state.clone()..user = user);
  }
}

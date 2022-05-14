import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/model/UserInfo.dart';

import 'UserState.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());

  Future<LoginState> login(String userAccount, String userPassword) async {
    LoginState loginState = await Api.get().login(userAccount, userPassword);
    if (loginState == LoginState.LOGIN_SUCCESS) {
      UserInfo userInfo = await Api.get().getUserInfo();
      emit(state.clone()..user = userInfo);
    }
    return loginState;
  }

  void changeUser(UserInfo user) {
    emit(state.clone()..user = user);
  }

  bool isLogin() {
    return state.user != null;
  }

  Future<List<Photo>> getCloudPhotoList() async {
    if (!isLogin()) throw new Exception("User not login");
    return await Api.get().getPicList();
  }
}

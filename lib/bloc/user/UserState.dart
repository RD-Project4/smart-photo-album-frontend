import 'package:smart_album/model/UserInfo.dart';

class UserState {
  UserInfo? user;
  String? token;

  UserState();

  clone() {
    return UserState()
      ..user = user
      ..token = token;
  }
}

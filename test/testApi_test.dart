import 'package:flutter_test/flutter_test.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/model/UserInfo.dart';

void main() {
  final test_account = "846630947@qq.com";
  final test_password = "123456";

  Api api = Api();

  group('User', () {
    test('register', () async {
      var state = await api.register(UserInfo(
          userAccount: test_account,
          userEmail: test_account,
          userName: "RichardLuo",
          userPhone: "13777581342",
          userPwd: test_password));
      expect(state, RegisterState.REGISTER_SUCCESS);
    });
    test('Login', () async {
      var state = await api.login(test_account, test_password);
      expect(state, LoginState.LOGIN_SUCCESS);
    });
    test('Logout', () async {
      api.authentication = new Authentication("", test_account);
      await api.logout();
    });
    test('GetUserInfo', () async {
      api.authentication = new Authentication("", test_account);
      UserInfo info = await api.getUserInfo();
      expect(info.userAccount, test_account);
    });
  });
}

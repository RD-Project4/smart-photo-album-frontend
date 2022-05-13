import 'package:flutter_test/flutter_test.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/model/UserInfo.dart';

void main() {
  final test_account = "commadama@outlook.com";
  final test_password = "123456";

  final test_friend_account = "abcd@outlook.com";
  final test_friend_password = "abcd@outlook.com";

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
    test('login', () async {
      var state = await api.login(test_account, test_password);
      expect(state, LoginState.LOGIN_SUCCESS);
    });
    test('getUserInfo', () async {
      await api.login(test_account, test_password);
      UserInfo info = await api.getUserInfo();
      expect(info.userAccount, test_account);
    });
    test('logout', () async {
      await api.login(test_account, test_password);
      await api.logout();
    });
    test('addFriend', () async {
      await api.login(test_account, test_password);
      var state = await api.register(UserInfo(
          userAccount: test_friend_account,
          userEmail: test_friend_password,
          userName: "RichardLuo",
          userPhone: "13777581342",
          userPwd: test_password));
      await api.addFriend(test_friend_account);
      var friendList = await api.getFriendInfo();
      expect(friendList[0].userEmail, test_friend_account);
    });
    test('getFriendInfo', () async {
      await api.login(test_account, test_password);
      var friendList = await api.getFriendInfo();
      expect(friendList[0].userEmail, test_friend_account);
    });
    test('uploadPic', () async {
      await api.login(test_account, test_password);
      await api.uploadPic([
        Photo.placeholder()..path = "C:\\Users\\CommA\\Downloads\\108.jpeg"
      ]);
      var photoList = await api.getPicList();
      expect(photoList.length, 1);
      await api.deletePic(photoList[0]);
      photoList = await api.getPicList();
      expect(photoList.length, 0);
    });
  });
}

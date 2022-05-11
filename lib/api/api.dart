import 'package:dio/dio.dart';
import 'package:smart_album/model/FriendInfo.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/model/UserInfo.dart';

enum LoginState {
  USER_NOT_EXIST,
  WRONG_PASSWORD,
  TOO_MANY_TIMES,
  HAS_LOGGED,
  LEFT_EMPTY,
  LOGIN_SUCCESS,
  UNKNOWN_ERROR
}

enum RegisterState {
  USER_EXISTED,
  REGISTER_SUCCESS,
}

class Authentication {
  String token;
  String userAccount;

  Authentication(this.token, this.userAccount);
}

class Api {
  static const String BASE_URL = 'http://124.223.68.12:8233/smartAlbum/';

  Dio dio = new Dio(BaseOptions(
    baseUrl: BASE_URL,
  ));

  Authentication? authentication;

  Api() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (options.queryParameters == null) options.queryParameters = {};
      options.queryParameters['token'] = authentication?.token ?? "";
      options.queryParameters['userAccount'] =
          authentication?.userAccount ?? "";
      return handler.next(options);
    }, onError: (error, handler) {
      return handler.next(error);
    }));
  }

  Future<LoginState> login(String userAccount, String userPassword) async {
    var response = await dio.post('login.do', queryParameters: {
      "userAccount": userAccount,
      'userPwd': userPassword,
    });
    authentication = Authentication("response.data['token']", userAccount);
    if (response.data["status"] > 5) {
      print(response.data["msg"]);
      return LoginState.UNKNOWN_ERROR;
    } else
      return LoginState.values[response.data["status"]];
  }

  logout() async {
    var response = await dio.post('logout.do');
    return;
  }

  Future<RegisterState> register(UserInfo user) async {
    var response =
        await dio.post('register.do', queryParameters: user.ToJson());
    return RegisterState.values[response.data["status"]];
  }

  sendEmailCode(String email) async {
    var response = await dio
        .post('sendemailcode.do', queryParameters: {"userEmail": email});
    return;
  }

  Future<bool> checkEmailCode(String code, String email) async {
    var response = await dio.post('checkemailcode.do',
        queryParameters: {"userEmail": email, "emailCode": code});
    return response.data["status"] == 0;
  }

  Future<UserInfo> getUserInfo() async {
    var response = await dio.post('showuser.do');
    if (response.data["status"] == 1)
      throw (DioError(
          requestOptions: response.requestOptions, response: response));
    return UserInfo.fromJson(response.data["data"]);
  }

  addFriend(String friendEmail) async {
    var response = await dio
        .post('addfriend.do', queryParameters: {"userEmail": friendEmail});
    return;
  }

  Future<FriendInfo> getFriendInfo() async {
    var response = await dio.post('showuserfriend.do');
    return FriendInfo.fromJson(response.data["data"]);
  }

  forgetPassword(UserInfo user, String newPassword) async {
    var response = await dio.post('forgetuserpwd.do',
        queryParameters: {"userEmail": user.userEmail, "userPwd": newPassword});
    return;
  }

  modifyPassword(String newPassword) async {
    var response = await dio
        .post('modifyuserpwd.do', queryParameters: {"userPwd": newPassword});
    return;
  }

  uploadPic(Photo photo, String label) async {
    var response = await dio.post('uploadcloudpic.do',
        data: FormData.fromMap({
          "file": MultipartFile.fromFileSync(photo.path),
          "label": label,
          "picOwner": authentication?.userAccount
        }));
    return;
  }

  Future<List<Photo>> getPic() async {
    var response = await dio.post('showpic.do',
        queryParameters: {"picOwner": authentication?.userAccount});
    List<Photo> photos = [];
    for (var item in response.data["data"]) {
      photos.add(Photo.fromJson(item));
    }
    return photos;
  }

  deletePic(Photo photo) async {
    if (!photo.isCloud) throw Exception("Not a cloud photo!");
    var response = await dio.post('deletepic.do', queryParameters: {
      "picId": photo.entityId,
      "picOwner": authentication?.userAccount
    });
    return;
  }

  Future<Photo> getPicByName(Photo name) async {
    var response = await dio.post('selectpicbyname.do', queryParameters: {
      "picLocalUrl": name,
      "picOwner": authentication?.userAccount
    });
    return Photo.fromJson(response.data["data"]);
  }

  Future<String> shareTo(Photo photo, List<FriendInfo> shareTo) async {
    if (!photo.isCloud) throw Exception("Not a cloud photo!");
    var response = await dio.post('addshare.do', queryParameters: {
      "shareContentId": photo.id,
      "shareObject": shareTo.map((e) => e.userEmail).join(','),
      "shareOwner": authentication?.userAccount
    });
    return response.data["data"];
  }

  Future<String> shareToEveryone(Photo photo) async {
    if (!photo.isCloud) throw Exception("Not a cloud photo!");
    var response = await dio.post('addshare.do', queryParameters: {
      "shareContentId": photo.id,
      "shareObject": "all",
      "shareOwner": authentication?.userAccount
    });
    return response.data["data"];
  }

  getShare(String shareId) async {
    var response =
        await dio.get('share.do', queryParameters: {"shareId": shareId});
    return response.data["data"];
  }
}

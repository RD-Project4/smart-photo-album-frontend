import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_album/model/FriendInfo.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/model/Share.dart';
import 'package:smart_album/model/UserInfo.dart';

class NotLoginException extends DioError {
  NotLoginException(Response response)
      : super(requestOptions: response.requestOptions, response: response);
}

class NotFoundException extends DioError {
  NotFoundException(Response response)
      : super(requestOptions: response.requestOptions, response: response);
}

class ServerInternalException extends DioError {
  ServerInternalException(Response response)
      : super(requestOptions: response.requestOptions, response: response);
}

class NotYourShareException extends DioError {
  NotYourShareException(Response response)
      : super(requestOptions: response.requestOptions, response: response);
}

enum LoginState {
  USER_NOT_EXIST,
  WRONG_PASSWORD,
  TOO_MANY_TIMES,
  HAS_LOGGED,
  OTHER_ERROR,
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

  static Api? _instance;

  static Api get() {
    if (_instance == null) {
      _instance = Api();
    }
    return _instance!;
  }

  Authentication? authentication;

  Api() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (options.queryParameters == null) options.queryParameters = {};
      if (!options.queryParameters.containsKey("token"))
        options.queryParameters['token'] = authentication?.token ?? "";
      if (!options.queryParameters.containsKey("userAccount"))
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
    if (response.data["status"] > 5) {
      return LoginState.UNKNOWN_ERROR;
    } else {
      LoginState state = LoginState.values[response.data["status"]];
      if (state == LoginState.LOGIN_SUCCESS)
        authentication = Authentication(response.data["data"], userAccount);
      return state;
    }
  }

  logout() async {
    var response = await dio.post('logout.do');
    if (response.data["status"] == 1) throw NotLoginException(response);
    return;
  }

  Future<RegisterState> register(UserInfo user) async {
    var response =
        await dio.post('register.do', queryParameters: user.toJson());
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
    if (response.data["status"] == 1) throw NotLoginException(response);
    return UserInfo.fromJson(response.data["data"]);
  }

  addFriend(String friendEmail) async {
    var response = await dio
        .post('addfriend.do', queryParameters: {"userEmail": friendEmail});
    if (response.data["status"] == 1)
      throw NotFoundException(response); // friendEmail does not exist
    if (response.data["status"] == 2) throw NotLoginException(response);
    return;
  }

  Future<List<FriendInfo>> getFriendInfo() async {
    var response = await dio.post('showuserfriend.do');
    if (response.data["status"] == 1) throw NotLoginException(response);
    return (response.data["data"] as List<dynamic>)
        .map((e) => FriendInfo.fromJson(e))
        .toList();
  }

  forgetPassword(UserInfo user, String newPassword) async {
    var response = await dio.post('forgetuserpwd.do',
        queryParameters: {"userEmail": user.userEmail, "userPwd": newPassword});
    return;
  }

  modifyPassword(String newPassword) async {
    var response = await dio
        .post('modifyuserpwd.do', queryParameters: {"userPwd": newPassword});
    if (response.data["status"] == 1) throw NotLoginException(response);
    return;
  }

  uploadPic(List<Photo> photoList) async {
    if (photoList.isEmpty) return;
    FormData formData = FormData();
    for (var i = 0; i < photoList.length; i++) {
      Photo photo = photoList[i];
      formData.files.add(
          MapEntry("imageList[$i]", await MultipartFile.fromFile(photo.path)));
      formData.fields.add(MapEntry("infoList[$i]", jsonEncode(photo.toJson())));
    }
    formData.fields
        .add(MapEntry("picOwner", authentication?.userAccount ?? ""));
    var response = await dio.post('uploadcloudpic.do', data: formData);
    if (response.data["status"] == 0 || response.data["status"] == 1)
      throw ServerInternalException(response); // Server error, try again
    if (response.data["status"] == 4) throw NotLoginException(response);
    return;
  }

  Future<List<Photo>> getPicList() async {
    var response = await dio.post('showpic.do',
        queryParameters: {"picOwner": authentication?.userAccount});
    List<Photo> photos = [];
    for (var item in response.data["data"]) {
      item["custom"] = jsonDecode(item["custom"]);
      photos.add(Photo.fromJson(item));
    }
    if (response.data["status"] == 1) throw NotLoginException(response);
    return photos;
  }

  deletePic(Photo photo) async {
    if (!photo.isCloud) throw Exception("Not a cloud photo!");
    var response = await dio.post('deletepic.do', queryParameters: {
      "picId": photo.cloudId,
      "picOwner": authentication?.userAccount
    });
    if (response.data["status"] == 2) throw ServerInternalException(response);
    if (response.data["status"] == 3) throw NotLoginException(response);
    return;
  }

  getPicUrlByCloudId(String id) {
    return BASE_URL +
        'getpic.do?picId=$id&userAccount=${authentication?.userAccount}&token=${authentication?.token}';
  }

  getPicThumbUrlByCloudId(String id) {
    return BASE_URL +
        'getpicthumb.do?picId=$id&userAccount=${authentication?.userAccount}&token=${authentication?.token}';
  }

  Future<Photo> getPicByName(Photo name) async {
    var response = await dio.post('selectpicbyname.do', queryParameters: {
      "picLocalUrl": name,
      "picOwner": authentication?.userAccount
    });
    return Photo.fromJson(response.data["data"]);
  }

  static toShareLink(String id) {
    return 'http://smartalbum.com/share-view?' + id;
  }

  Future<String> shareTo(
      List<Photo> photoList, List<FriendInfo> shareTo) async {
    for (var photo in photoList) {
      if (!photo.isCloud) throw Exception("Include non cloud photo!");
    }
    var response = await dio.post('addshare.do', data: {
      "picIdList": photoList.map((photo) => photo.cloudId).toList(),
      "shareObjectList": shareTo.map((e) => e.userEmail).toList(),
      "isAll": false,
      "shareOwner": authentication?.userAccount
    });
    if (response.data["status"] == 1) throw NotLoginException(response);
    return response.data["data"]; // Share id
  }

  Future<String> shareToEveryone(List<Photo> photoList) async {
    for (var photo in photoList) {
      if (!photo.isCloud) throw Exception("Include non cloud photo!");
    }
    var response = await dio.post('addshare.do', data: {
      "picIdList": photoList.map((photo) => photo.cloudId).toList(),
      "shareObjectList": List.empty(),
      "isAll": true,
      "shareOwner": authentication?.userAccount
    });
    if (response.data["status"] == 1) throw NotLoginException(response);
    return response.data["data"];
  }

  Future<List<Photo>> getSharePhotoList(String shareId) async {
    var response =
        await dio.post('share.do', queryParameters: {"shareId": shareId});
    if (response.data["status"] == 1)
      throw NotLoginException(response);
    else if (response.data["status"] == 2)
      throw NotYourShareException(response);
    List<Photo> photos = [];
    for (var item in response.data["data"]) {
      item["custom"] = jsonDecode(item["custom"]);
      photos.add(Photo.fromJson(item));
    }
    return photos;
  }

  Future<List<Share>> getShareList() async {
    var response = await dio.post('getShareList.do');
    return (response.data["data"] as List<dynamic>)
        .map((share) => Share.fromJson(share))
        .toList();
  }

  deleteShare(Share share) async {
    var response = await dio
        .post('deleteShare.do', queryParameters: {"shareId": share.shareId});
    if (response.data["status"] == 1)
      throw NotLoginException(response);
    else if (response.data["status"] == 2)
      throw NotYourShareException(response);
    return;
  }
}

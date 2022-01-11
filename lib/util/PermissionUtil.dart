import 'package:permission_handler/permission_handler.dart';

/// 获取权限
class PermissionUtil {
  
  static Future requestAllPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.camera,
      Permission.photos,
      Permission.speech,
      Permission.storage,
      Permission.location,
      Permission.phone,
      Permission.notification,
    ].request();

    if (await Permission.camera.isGranted) {
      print("相机权限申请通过");
    } else {
      print("相机权限申请失败");
    }

    if (await Permission.photos.isGranted) {
      print("照片权限申请通过");
    } else {
      print("照片权限申请失败");
    }

    if (await Permission.speech.isGranted) {
      print("语音权限申请通过");
    } else {
      print("语音权限申请失败");
    }

    if (await Permission.storage.isGranted) {
      print("文件权限申请通过");
    } else {
      print("文件权限申请失败");
    }

    if (await Permission.location.isGranted) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请失败");
    }

    if (await Permission.phone.isGranted) {
      print("手机权限申请通过");
    } else {
      print("手机权限申请失败");
    }

    if (await Permission.notification.isGranted) {
      print("通知权限申请通过");
    } else {
      print("通知权限申请失败");
    }
  }

  /// 相机权限
  static Future<bool> requestCameraPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.camera,
    ].request();

    return await Permission.camera.isGranted;
  }

  /// 照片权限
  static Future<bool> requestPhotosPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.photos,
    ].request();

    return await Permission.photos.isGranted;
  }

  /// 语音权限
  static Future<bool> requestSpeechPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.speech,
    ].request();


    return await Permission.speech.isGranted;
  }

  /// 文件权限
  static Future<bool> requestStoragePermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.storage,
    ].request();
    return await Permission.storage.isGranted;
  }

  /// 定位权限
  static Future<bool> requestLocationPermission() async {
    Map<Permission, PermissionStatus> permission = await [

      Permission.location,
    ].request();

    return await Permission.location.isGranted;
  }

  /// 手机权限
  static Future<bool> requestPhonePermission() async {
    Map<Permission, PermissionStatus> permission = await [

      Permission.phone,
    ].request();

    return await Permission.phone.isGranted;
  }

  /// 通知权限
  static Future<bool> requestNotificationPermission() async {
    Map<Permission, PermissionStatus> permission = await [

      Permission.notification,
    ].request();

    return await Permission.notification.isGranted;
  }

}

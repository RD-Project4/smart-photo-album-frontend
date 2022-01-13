import 'package:permission_handler/permission_handler.dart';

/// 获取权限
class PermissionUtil {

  /// 检查相机权限
  static Future<bool> checkCameraPermission() async{
    return await Permission.camera.isGranted;
  }


  /// 相机权限
  static Future<bool> requestCameraPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.camera,
    ].request();

    return await checkCameraPermission();
  }

  /// 检查照片权限
  static Future<bool> checkPhotosPermission() async{
    return await Permission.photos.isGranted;
  }

  /// 照片权限
  static Future<bool> requestPhotosPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.photos,
    ].request();

    return await checkPhotosPermission();
  }

  /// 检查语音权限
  static Future<bool> checkSpeechPermission() async{
    return await Permission.speech.isGranted;
  }

  /// 语音权限
  static Future<bool> requestSpeechPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.speech,
    ].request();


    return await checkSpeechPermission();
  }

  /// 检查文件权限
  static Future<bool> checkStoragePermission() async{
    return await Permission.storage.isGranted;
  }

  /// 文件权限
  static Future<bool> requestStoragePermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.storage,
    ].request();
    return await checkStoragePermission();
  }

  /// 检查定位权限
  static Future<bool> checkLocationPermission() async{
    return await Permission.location.isGranted;
  }

  /// 定位权限
  static Future<bool> requestLocationPermission() async {
    Map<Permission, PermissionStatus> permission = await [

      Permission.location,
    ].request();

    return await checkLocationPermission();
  }

  /// 检查手机权限
  static Future<bool> checkPhonePermission() async{
    return await Permission.phone.isGranted;
  }

  /// 手机权限
  static Future<bool> requestPhonePermission() async {
    Map<Permission, PermissionStatus> permission = await [

      Permission.phone,
    ].request();

    return await checkPhonePermission();
  }

  /// 检查通知权限
  static Future<bool> checkNotificationPermission() async{
    return await Permission.notification.isGranted;
  }

  /// 通知权限
  static Future<bool> requestNotificationPermission() async {
    Map<Permission, PermissionStatus> permission = await [

      Permission.notification,
    ].request();

    return await checkNotificationPermission();
  }

}

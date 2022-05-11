import 'dart:async';

import 'package:path_provider/path_provider.dart';

class CommonUtil {
  static void nextTick(Function function) {
    Future.delayed(Duration.zero, () async {
      function();
    });
  }

  static String capitalizeFirstLetter(String string) {
    return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
  }

  static Future<String> getDirPath() async {
    final _dir = await getApplicationDocumentsDirectory();
    return _dir.path;
  }

  static bool notNonOr0(num? num) {
    return num != null && num != 0;
  }
}

import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class CommonUtil {
  static void nextTick(Function function) {
    Future.delayed(Duration.zero, () async {
      function();
    });
  }

  static Future<String> getDirPath() async {
    final _dir = await getApplicationDocumentsDirectory();
    return _dir.path;
  }
}

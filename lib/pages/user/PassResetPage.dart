import 'package:flutter/material.dart';
import 'package:smart_album/widgets/HiddenAppbar.dart';
import 'package:smart_album/widgets/user/PassResetForm.dart';

/// 重设密码页
class PassResetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: HiddenAppbar(), body: PassResetForm());
  }
}

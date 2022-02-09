import 'package:flutter/material.dart';
import 'package:smart_album/widgets/HiddenAppbar.dart';
import 'package:smart_album/widgets/user/RegisterForm.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: HiddenAppbar(), body: RegisterForm());
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_album/util/RegExpUtil.dart';
import 'package:smart_album/util/CommonUtil.dart';
import 'package:smart_album/widgets/user/CountdownButton.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var _index = 0; // 当前在第几步（从0计数）
  final _formKey = GlobalKey<FormState>();
  var _ableToContinue = false;
  var _ableToCancel = true;
  var _username = '';
  var _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Stepper(
            currentStep: _index,
            type: StepperType.horizontal,
            onStepCancel: _onStepCancel,
            onStepContinue: _onStepContinue,
            steps: <Step>[
              Step(
                  title: Text(''),
                  isActive: _index >= 0,
                  content: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Email'),
                    validator: _emailValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  )),
              Step(
                  title: Text(''),
                  isActive: _index >= 1,
                  content: Stack(
                    alignment: Alignment(1.0, 1.0),
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            hintText: 'Validate code'),
                      ),
                      CountdownButton()
                    ],
                  )),
              Step(
                  title: Text(''),
                  isActive: _index >= 2,
                  content: Column(children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Username'),
                      validator: _usernameValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Password'),
                      validator: _passwordValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Confirm password'),
                      validator: (v) {
                        if (v != _password) {
                          return 'Passwords do not match';
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    )
                  ]))
            ]));
  }

  /// 当点击取消按钮时
  void _onStepCancel() {
    if (_index > 0) {
      setState(() {
        _index -= 1;
      });
    } else if (_index == 0) {
      Navigator.pop(context);
    }
  }

  /// 当点击继续按钮时
  void _onStepContinue() {
    if (!_ableToContinue) {
      return;
    }

    if (_index < 2) {
      setState(() {
        _index += 1;
      });
    } else if (_index == 2) {
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    }
  }

  String? _emailValidator(v) {
    if (!RegExp(RegExpUtil.EMAIL).hasMatch(v!)) {
      CommonUtil.nextTick(() {
        if (_ableToContinue) {
          setState(() {
            _ableToContinue = false;
          });
        }
      });

      return 'Please enter a valid email';
    } else {
      CommonUtil.nextTick(() {
        if (!_ableToContinue) {
          setState(() {
            _ableToContinue = true;
          });
        }
      });
    }
  }

  String? _usernameValidator(v) {
    if (v.length < 2) {
      return 'Username is too short';
    } else if (v.length > 20) {
      return 'Username is too long';
    } else if (!RegExp(r'^[\u4e00-\u9fa5_\-a-zA-Z0-9]+$').hasMatch(v)) {
      return 'Username contains invalid characters';
    } else {
      CommonUtil.nextTick(() {
        setState(() {
          _username = v;
        });
      });
    }
  }

  String? _passwordValidator(v) {
    if (v.length < 6) {
      return 'Password is too short';
    } else if (v.length > 30) {
      return 'Password is too long';
    } else if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,30}$')
        .hasMatch(v)) {
      return 'Password needs to contain at least one uppercase letter, one lowercase letter and one number ';
    } else {
      CommonUtil.nextTick(() {
        setState(() {
          _password = v;
        });
      });
    }
  }


  /// 验证邮箱验证码是否正确
  void _verifyCode() {}
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_album/util/RegExpUtil.dart';
import 'package:smart_album/util/CommonUtil.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var _index = 0; // 当前在第几步（从0计数）
  var _sendCodeCooling = 0; // 倒计时冷却
  late Timer _timer;
  final _formKey = GlobalKey<FormState>();
  var _ableToContinue = false;
  var _ableToCancel = true;

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
                  content: Container(
                      child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Email'),
                    validator: _step1Validator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ))),
              Step(
                  title: Text(''),
                  isActive: _index >= 1,
                  content: Stack(alignment: Alignment(1.0, 1.0), children: [
                    TextField(
                      decoration: const InputDecoration(
                          // border: OutlineInputBorder(),
                          hintText: 'Validate code'),
                    ),
                    TextButton(
                        onPressed: _sendCodeCooling == 0 ? _sendCode : null,
                        child: Text(
                            'SEND CODE${_sendCodeCooling == 0 ? '' : '($_sendCodeCooling)'}'))
                  ])),
              Step(
                  title: Text(''),
                  isActive: _index >= 2,
                  content: Column(children: [
                    TextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Username'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Password'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Confirm password'),
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

  String? _step1Validator(v) {
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
      return null;
    }
  }

  /// 点击发送邮箱验证码按钮
  void _sendCode() {
    // TODO: 对接请求邮箱验证码api

    setState(() {
      _sendCodeCooling = 60;
    });

    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          setState(() {
            if (_sendCodeCooling < 1) {
              _timer.cancel();
            } else {
              _sendCodeCooling--;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  /// 验证邮箱验证码是否正确
  void _verifyCode() {}
}

import 'dart:async';

import 'package:flutter/material.dart';

/// 倒计时按钮，用在注册页面
class CountdownButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<CountdownButton> {
  var _sendCodeCooling = 0; // 倒计时冷却
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: _sendCodeCooling == 0 ? _sendCode : null,
        child: Text(
            'SEND CODE${_sendCodeCooling == 0 ? '' : '($_sendCodeCooling)'}'));
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
}

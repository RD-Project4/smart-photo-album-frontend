import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// 倒计时按钮，用在注册页面
class CountdownButton extends StatefulWidget {
  final email;
  CountdownButton({Key? key, required this.email}) : super(key: key);
  @override
  // _CountdownButtonState createState() =>
  //     _CountdownButtonState(email: this.email);
  State<StatefulWidget> createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<CountdownButton> {
  var _sendCodeCooling = 0; // 倒计时冷却
  late Timer _timer;

  final email;
  _CountdownButtonState({this.email});
  var _status = 4;
  var _msg = '';

  postData() async {
    print('posting data');
    print(this.email);

    var apiurl =
        Uri.parse('http://124.223.68.12:8233/smartAlbum/sendemailcode.do');

    var response = await http.post(apiurl, body: {"userEmail": this.email});
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
    });
  }

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
    print('you have send code');
    print(this.email);

    postData();
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

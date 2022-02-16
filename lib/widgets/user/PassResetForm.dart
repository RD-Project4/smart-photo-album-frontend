import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_album/util/RegExpUtil.dart';
import 'package:smart_album/util/CommonUtil.dart';
import 'package:smart_album/widgets/user/CountdownButton.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class PassResetForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PassResetFormState();
}

class _PassResetFormState extends State<PassResetForm> {
  var _index = 0; // 当前在第几步（从0计数）
  final _formKey = GlobalKey<FormState>();

  var _sendCodeCooling = 0; // 倒计时冷却
  late Timer _timer;

  var _ableToContinue = true;
  var _ableToCancel = true;
  var _username = '';
  var _password = '';
  var email = '';
  var _validateCode = '';
  var _status = 4;
  var _msg = '';

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
                  content: Stack(
                    alignment: Alignment(1.0, 1.0),
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          // border: OutlineInputBorder(),
                            hintText: 'Validate code'),
                        onChanged: (value) {
                          setState(() {
                            this._validateCode = value;
                          });
                        },
                      ),
                      TextButton(
                          onPressed: _sendCodeCooling == 0 ? _sendCode : null,
                          child: Text(
                              'SEND CODE${_sendCodeCooling == 0 ? '' : '($_sendCodeCooling)'}')),
                      Container(
                        child: Text(
                          "${this._msg}",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  )),
              Step(
                  title: Text(''),
                  isActive: _index >= 1,
                  content: Column(children: [
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
      if (_index == 1) {
        _verifyCode();
      }
      if (_index == 0) {
        setState(() {
          _index += 1;
        });
      }
    } else if (_index == 2) {
      print(this._username);
      print(this.email);
      print(this._password);

      _register();
      // Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
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
  void _verifyCode() async {
    var apiUrl =
    Uri.parse('http://124.223.68.12:8233/smartAlbum/checkemailcode.do');
    var response = await http.post(apiUrl,
        body: {"emailCode": this._validateCode, "userEmail": this.email});
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
    });
    if (this._status == 0) {
      setState(() {
        _index += 1;
      });
    }
  }

  void _sendCode() {
    // TODO: 对接请求邮箱验证码api
    // print('you have send code');
    // print(this.email);

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

  _register() async {
    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/register.do');

    var response = await http.post(apiurl, body: {
      "userAccount": "${this.email}",
      "userPwd": "${this._password}",
      "userName": "${this._username}",
      "userEmail": "${this.email}",
      "userPhone": "18857561268"
    });
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
    });
    if (this._status == 0) {
      // Navigator.of(context).pushReplacementNamed('/loginPage');
    } else {
      Navigator.of(context).pushReplacementNamed('/');
    }
    print(_status);
  }
}

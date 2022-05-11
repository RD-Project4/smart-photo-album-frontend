import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:smart_album/pages/Tabs.dart';
import 'package:smart_album/pages/tabs/Setting.dart';
import 'package:smart_album/util/Global.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create a Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  FocusNode _accountFocus = FocusNode();
  FocusNode _passFocus = FocusNode();

  String account = '';
  String password = '';

  var userId = '';
  var userAccount = '';
  var userName = '';
  var userEmail = '';
  var userProfile = '';
  var userPhone = '';

  var _status = 4;
  var _msg = '';

  postData() async {
    _accountFocus.unfocus();
    _passFocus.unfocus();
    var apiUrl = Uri.parse('${Global.API_URL}/login.do');

    var response = await http.post(apiUrl,
        body: {"userAccount": this.account, "userPwd": this.password});

    var res = jsonDecode(response.body);

    var _status = res['status'];

    setState(() {
      this._status = jsonDecode(response.body)["status"];
      Setting.state = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
      // Setting.userId = jsonDecode(response.body)["data"]["userId"];
      // this.userId = jsonDecode(response.body)["data"]["userId"];
      this.userAccount = jsonDecode(response.body)["data"];
      Setting.userAccount = jsonDecode(response.body)["data"];
      // this.userName = jsonDecode(response.body)["data"]["userName"];
      // this.userEmail = jsonDecode(response.body)["data"]["userEmail"];
      // Setting.userEmail = jsonDecode(response.body)["data"]["userEmail"];
      // this.userProfile = jsonDecode(response.body)["data"]["userProfile"];
      // this.userPhone = jsonDecode(response.body)["data"]["userPhone"];
    });

    if (_status == 3) {
      showToast("The user has logged in", textStyle: TextStyle(fontSize: 20));
    } else if (_status == 0 || _status == 1) {
      showToast("Mail or password is incorrect",
          textStyle: TextStyle(fontSize: 20));
    } else if (_status == 5) {
      final prefs = await SharedPreferences.getInstance();


      Tabs.loginstate = 0;
      Navigator.pushNamed(
        context,
        '/',
      ); //arguments: {"userId": this.userId, "userEmail": this.userEmail}
    } else {
      showToast("Login error", textStyle: TextStyle(fontSize: 20));
    }
  }

  // getsession() async {
  //   var apiurl =
  //       Uri.parse('http://124.223.68.12:8233/smartAlbum/getsessionid.do');
  //   var response = await http.post(apiurl);
  //   print('Response status : ${response.statusCode}');
  //   print('Response status : ${response.body}');
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Email'),
            focusNode: _accountFocus,
            onChanged: (value) {
              setState(() {
                account = value;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Password'),
            focusNode: _passFocus,
            obscureText: true,
            onChanged: (v) {
              setState(() {
                password = v;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          LoginButton(
            ableToLogin: account != '' && password != '',
            onTap: () {
              postData();
            },
          ),
          // Container(
          //   child: Text(
          //     "${this._msg}",
          //     style: TextStyle(color: Colors.red),
          //   ),
          // )
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final bool ableToLogin;
  final onTap;

  const LoginButton({Key? key, required this.ableToLogin, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ableToLogin
                ? Positioned(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('images/login_page/login_btn_bg2.gif'),
                    ),
                  )
                : Positioned(
                    child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                  )),
            Positioned(
                child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ))
          ],
        ));
  }
}

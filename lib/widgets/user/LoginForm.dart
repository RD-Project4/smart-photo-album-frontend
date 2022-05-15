import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
import 'package:smart_album/pages/tabs/Setting.dart';
import 'package:smart_album/util/Global.dart';

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

    UserCubit cubit = context.read<UserCubit>();
    LoginState state = await cubit.login(account, password);

    if (state == LoginState.HAS_LOGGED) {
      showToast("The user has logged in", textStyle: TextStyle(fontSize: 20));
    } else if (state == LoginState.WRONG_PASSWORD) {
      showToast("Mail or password is incorrect",
          textStyle: TextStyle(fontSize: 20));
    } else if (state == LoginState.LOGIN_SUCCESS) {
      // Tabs.loginstate = 0;
      Navigator.of(context)
          .pop(); //arguments: {"userId": this.userId, "userEmail": this.userEmail}
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

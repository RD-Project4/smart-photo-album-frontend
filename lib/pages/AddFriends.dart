import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
import 'package:smart_album/pages/Tabs.dart';
import 'package:smart_album/pages/tabs/Setting.dart';

// Create a Form widget.
class AddFriends extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddFriendsState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class _AddFriendsState extends State<AddFriends> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  String account = '';
  String password = '';

  // var userId = '';
  // var userAccount = '';
  // var userName = '';
  // var userEmail = '';
  // var userProfile = '';
  // var userPhone = '';

  var _status = 4;
  var _msg = '';

  _addfriends() async {
    if (context.read<UserCubit>().isLogin()) showToast("Please login first");
    await Api.get().addFriend(account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Email'),
              onChanged: (value) {
                account = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            LoginButton(
              ableToLogin: account != '',
              onTap: () {
                _addfriends();
              },
            ),
            Container(
              child: Text(
                "${this._msg}",
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
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

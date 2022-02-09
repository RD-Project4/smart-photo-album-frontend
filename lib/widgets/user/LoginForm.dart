import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:passwordfield/passwordfield.dart';
import 'package:smart_album/pages/tabs/Setting.dart';

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

  String account = '';
  String password = '';

  var userId;
  var userAccount = '';
  var userName = '';
  var userEmail = '';
  var userProfile = '';
  var userPhone = '';

  var _status = 4;
  var _msg = '';

  postData() async {
    print('posting data');
    print(this.account);
    print(this.password);
    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/login.do');

    var response = await http.post(apiurl,
        body: {"userAccount": this.account, "userPwd": this.password});
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      Setting.state = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
      this.userId = jsonDecode(response.body)["data"]["userId"];
      this.userAccount = jsonDecode(response.body)["data"]["userAccount"];
      this.userName = jsonDecode(response.body)["data"]["userName"];
      this.userEmail = jsonDecode(response.body)["data"]["userEmail"];
      this.userProfile = jsonDecode(response.body)["data"]["userProfile"];
      this.userPhone = jsonDecode(response.body)["data"]["userPhone"];
    });
    if (this._status == 5) {
      print(' login jump to setting');
      Navigator.pushNamed(context, '/setting',
          arguments: {"userId": this.userId, "userEmail": this.userEmail});
    } else {
      print('jump to login');
    }
  }

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
            onChanged: (value) {
              setState(() {
                account = value;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          PasswordField(
            passwordConstraint: '.*',
            border: PasswordBorder(border: OutlineInputBorder()),
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
          Container(
            child: Text(
              "${this._msg}",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}

// class LoginButton extends StatefulWidget {
//   final bool ableToLogin;
//   final String password;
//   final String account;
//
//   LoginButton(
//       {Key? key,
//       required this.ableToLogin,
//       required this.account,
//       required this.password})
//       : super(key: key);
//
//   @override
//   _LoginButtonState createState() => _LoginButtonState();
// }
//
// class _LoginButtonState extends State<LoginButton> {
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           print(widget.ableToLogin);
//           print(widget.account);
//           print(widget.password);
//         },
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             widget.ableToLogin
//                 ? Positioned(
//                     child: CircleAvatar(
//                       radius: 40,
//                       backgroundImage:
//                           AssetImage('images/login_page/login_btn_bg2.gif'),
//                     ),
//                   )
//                 : Positioned(
//                     child: CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.grey,
//                   )),
//             Positioned(
//                 child: Icon(
//               Icons.arrow_forward_ios,
//               color: Colors.white,
//             ))
//           ],
//         ));
//   }
// }

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

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:passwordfield/passwordfield.dart';

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
              print('account $account');
              print('password $password');
            },
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

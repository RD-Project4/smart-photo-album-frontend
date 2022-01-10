import 'package:flutter/material.dart';
import 'package:smart_album/widgets/Form.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text('Login'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Align(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle_outlined, size: 120),
                  LoginForm()
                ]),
          ))
        ]));
  }
}

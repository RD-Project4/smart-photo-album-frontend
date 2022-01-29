import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_album/widgets/LoginForm.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // 防止调起软键盘顶起页面
        extendBodyBehindAppBar: true, // 不计算AppBar的体积
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text('Login'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(children: [
          Align(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'images/logo.png',
                        width: 60,
                      ),
                      Text(
                        "Smart Album",
                        style: TextStyle(
                            fontFamily: 'BeauRivageOne', fontSize: 50),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LoginForm(),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register-first');
                          },
                          child: Text('Registry')),
                      Text('|'),
                      TextButton(
                          onPressed: () {}, child: Text('Forgot password?'))
                    ],
                  )
                ]),
          ))
        ]));
  }
}

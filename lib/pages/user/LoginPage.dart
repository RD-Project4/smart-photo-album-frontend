import 'package:flutter/material.dart';
import 'package:smart_album/util/ThemeUtil.dart';
import 'package:smart_album/widgets/HiddenAppbar.dart';
import 'package:smart_album/widgets/user/LoginForm.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeUtil.setSystemOverlayLight(context);

    return Scaffold(
        resizeToAvoidBottomInset: false, // 防止调起软键盘顶起页面
        extendBodyBehindAppBar: true, // 不计算AppBar的体积
        appBar: HiddenAppbar(),
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
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Image.asset(
                          'images/logo.png',
                          width: 90,
                        ),
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
                            Navigator.pushNamed(
                                context, '/register-page'); //register-page
                          },
                          child: Text('Registry')),
                      Text('|'),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/pass-reset');
                          },
                          child: Text('Forgot password?'))
                    ],
                  )
                ]),
          ))
        ]));
  }
}

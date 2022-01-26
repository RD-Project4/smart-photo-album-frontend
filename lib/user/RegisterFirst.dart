import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class RegisterFirstPage extends StatefulWidget {
  RegisterFirstPage({Key? key}) : super(key: key);

  @override
  _RegisterFirstPageState createState() => _RegisterFirstPageState();
}

class _RegisterFirstPageState extends State<RegisterFirstPage> {
  var _username = new TextEditingController(); //初始赋值
  var _password = new TextEditingController(); //初始赋值
  var _useraccount = new TextEditingController();
  var _useremail = new TextEditingController();
  var _userphone = new TextEditingController();
  int _status = 4;
  String _msg = '';

  postData() async {
    print('posting data');

    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/register.do');

    var response = await http.post(apiurl, body: {
      "userAccount": "${this._useraccount.text}",
      "userPwd": "${this._password.text}",
      "userName": "${this._username.text}",
      "userEmail": "${this._useremail.text}",
      "userPhone": "${this._userphone.text}"
    });
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
    });
    if (this._status == 0) {
      print('jump to setting');
      Navigator.of(context).pushReplacementNamed('/loginPage');
    } else {
      Navigator.of(context).pushReplacementNamed('/');
    }
    print(_status);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _useraccount.text = '';
    _username.text = '';
    _password.text = '';
    _useremail.text = '';
    _userphone.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.cyanAccent[900],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.people),
                    hintText: "please enter your useraccount",
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    _useraccount.text = value;
                  });
                },
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.password),
                    hintText: "please enter your password",
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    _password.text = value;
                  });
                },
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "please enter your username",
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    _username.text = value;
                  });
                },
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.mail),
                    hintText: "please enter your Email",
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    _useremail.text = value;
                  });
                },
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.smartphone_rounded),
                    hintText: "please enter your phonenumber",
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    _userphone.text = value;
                  });
                },
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   margin: EdgeInsets.all(20),
            //   height: 50,
            //   child: TextField(
            //     obscureText: true,
            //     decoration: InputDecoration(
            //         icon: Icon(Icons.refresh_outlined),
            //         hintText: "please enter your password again",
            //         border: OutlineInputBorder()),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              width: 200,
              child: OutlinedButton(
                onPressed: () {
                  print(this._username.text);
                  print(this._password.text);
                  if (this._password.text == '' ||
                      this._username.text == '' ||
                      this._useraccount == '' ||
                      this._useremail == '' ||
                      this._userphone == '') {
                    Navigator.of(context)
                        .pushReplacementNamed('/registerfirst');
                  } else {
                    postData();
                  }

                  // Navigator.of(context).pushReplacementNamed(
                  //     '/registersecond'); //替换路由，把当前的页面换成钱一个页面，这样点击返回时会返回到上上个页面
                },
                child: Text('Next'),
              ),
            )
          ],
        ),
      ),
      // Padding(
      //   padding: EdgeInsets.all(10),
      //   child: Column(
      //     children: [
      //       TextField(
      //         decoration: InputDecoration(hintText: "please enter username"),
      //         onChanged: (value) {
      //           setState(() {
      //             _username.text = value;
      //           });
      //         },
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       Container(
      //         margin: EdgeInsets.all(20),
      //         height: 50,
      //         width: 200,
      //         child: OutlinedButton(
      //           onPressed: () {
      //             print(this._username.text);
      //             Navigator.of(context).pushNamed('/registersecond');
      //             // Navigator.of(context).pushReplacementNamed(
      //             //     '/registersecond'); //替换路由，把当前的页面换成钱一个页面，这样点击返回时会返回到上上个页面
      //           },
      //           child: Text('Next'),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class TextDemo extends StatelessWidget {
  const TextDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(20),
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.people),
                  hintText: "please enter your username",
                  border: OutlineInputBorder()),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(20),
            height: 50,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  icon: Icon(Icons.password),
                  hintText: "please enter your password",
                  border: OutlineInputBorder()),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(20),
            height: 50,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  icon: Icon(Icons.refresh_outlined),
                  hintText: "please enter your password again",
                  border: OutlineInputBorder()),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            height: 50,
            width: 200,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/registersecond');
                // Navigator.of(context).pushReplacementNamed(
                //     '/registersecond'); //替换路由，把当前的页面换成钱一个页面，这样点击返回时会返回到上上个页面
              },
              child: Text('Next'),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_album/pages/Tabs.dart';

class Setting extends StatefulWidget {
  // final arguments;
  static int state = 4;

  static var userId = '';
  static var userEmail = '';
  static var userName = '';
  static var session = '';
  static var userAccount = '';

  Setting({
    Key? key,
    // this.arguments,
  }) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  // final arguments;

  // _SettingState({
  //   this.arguments,
  // });

  bool flag = false;
  IconData changeIcon = Icons.arrow_drop_up_outlined;
  int _status = 4;
  String _msg = '';

  _logout() async {
    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/logout.do');
    var response = await http.post(apiurl,
        body: {"userAccount": "1073638314@qq.com"}); //Setting.userEmail
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
    });
    if (this._status == 0) {
      print('logut jump to setting');
      Setting.userId = '';
      Setting.userEmail = '';
      Setting.userName = '';
      Navigator.of(context).pushReplacementNamed('/');
    }
    print(_status);
  }

  /// 用户栏
  Widget _buildUserInfo(userName) {
    if (userName == "") {
      return GestureDetector(
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/default_avatar.png'),
            ),
            SizedBox(width: 25),
            Text(
              "Click to login",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            )
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/login-page');
        },
      );
    } else {
      return Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F0720%252F27836c7fj00qwiper0016c000hs00hsg.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646826366&t=14ab6dfab50dc92f5d07cdc12c9a5ddf"),
          ),
          SizedBox(width: 25),
          Text(
            "${Setting.userName}",
            style: TextStyle(fontSize: 25),
          )
        ],
      );
    }
  }

  Widget _buildSettingsAfterLogin() {
    return Column(
      children: [
        SettingSelection(
          icon: Icons.group_add,
          title: Text("Add Other Accounts"),
          onPressed: () {
            Navigator.pushNamed(context, '/login-page');
          },
        ),
        SettingSelection(
            icon: Icons.app_blocking_rounded,
            title: Text(
              "Quit Your Account",
              style: TextStyle(color: Colors.red[600]),
            ),
            onPressed: () {
              _logout();
              Tabs.loginstate = 1;
            }),
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Icon(Icons.cloud),
              ),
              Expanded(
                  flex: 4,
                  child: ListTile(
                    title: Text("Storage"),
                    subtitle: Text("Used：1GB，total 15GB"),
                  ))
            ],
          ),
        ),
        SettingSelection(
          icon: Icons.phone_iphone,
          title: Text('400 items can be deleted from this device'),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Tabs.loginstate == 1) {
      Setting.userAccount = '';
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // AspectRatio(
          //   //Aspectratio
          //   aspectRatio: 20 / 9,
          //   child: Image.network(
          //     value['imageUrl'],
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: _buildUserInfo(Setting.userName)

                    // leading: CircleAvatar(
                    //   //专门用来处理头像
                    //   backgroundImage: NetworkImage(
                    //       'https://www.itying.com/images/flutter/1.png'),
                    // ),
                    // title: Text("Username=${arguments['usetId']}"),
                    // subtitle: Text(
                    //   "arguments['userEmail']",
                    //   overflow: TextOverflow.ellipsis,
                    //   maxLines: 2,
                    // ),
                    ),
              ),
              // Expanded(
              //     flex: 1,
              //     child: RaisedButton.icon(
              //       elevation: 0,
              //       color: Colors.white,
              //       shape: CircleBorder(side: BorderSide(color: Colors.white)),
              //       onPressed: () {
              //         setState(() {
              //           flag = !flag;
              //           if (flag) {
              //             this.changeIcon = Icons.arrow_drop_down_outlined;
              //           } else {
              //             this.changeIcon = Icons.arrow_drop_up_outlined;
              //           }
              //         });
              //       },
              //       icon: Icon(this.changeIcon),
              //       label: Text(''),
              //     ))
            ],
          ),
          // _buildSettingsAfterLogin(),
          Setting.userName != "" ? _buildSettingsAfterLogin() : Container(),
          SettingSelection(
            icon: Icons.health_and_safety_outlined,
            title: Text("Your data in the album"),
            onPressed: () {},
          ),
          SettingSelection(
            icon: Icons.help,
            title: Text("Help and Feedback"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class SettingSelection extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final void Function() onPressed;

  const SettingSelection(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // style: ButtonStyle(
      //   backgroundColor: MaterialStateProperty.all(Colors.white),
      //   overlayColor: MaterialStateProperty.all(Colors.grey[200]),
      // ),
      onPressed: onPressed,
      child: Row(
        children: [
          Expanded(
            child: Icon(
              icon,
              color: Colors.black,
            ),
            flex: 1,
          ),
          Expanded(
              flex: 4,
              child: ListTile(
                title: title,
              ))
        ],
      ),
    );
  }
}

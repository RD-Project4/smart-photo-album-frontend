import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/src/provider.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
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
  bool flag = false;
  IconData changeIcon = Icons.arrow_drop_up_outlined;
  int _status = 4;
  String _msg = '';
  UserCubit? userCubit;
  var mainColor = Color.fromRGBO(243, 247, 249, 1);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _logout() async {
    // var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/logout.do');
    // var response = await http.post(apiurl,
    //     body: {"userAccount": Setting.userEmail}); //Setting.userEmail
    // print('Response status : ${response.statusCode}');
    // print('Response status : ${response.body}');
    // setState(() {
    //   this._status = jsonDecode(response.body)["status"];
    //   this._msg = jsonDecode(response.body)["msg"];
    // });
    // if (this._status == 0) {
    //   print('logut jump to setting');
    //   Setting.userId = '';
    //   Setting.userEmail = '';
    //   Setting.userName = '';
    //   Navigator.of(context).pushReplacementNamed('/');
    // }
    // print(_status);
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

  /// 登陆后显示的组件
  Widget _buildSettingsAfterLogin() {
    return _buildSettingCard(
      [
        SettingSelection(
          icon: Icons.favorite,
          title: Text("My Favorites"),
          onPressed: () {},
          iconColor: Colors.red,
        ),
        SettingSelection(
          icon: Icons.group,
          title: Text("My Friends"),
          onPressed: () {
            Navigator.pushNamed(context, '/friends');
          },
          iconColor: Colors.indigo,
        ),
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Icon(Icons.cloud),
              ),
              Expanded(
                  flex: 16,
                  child: ListTile(
                    title: Text("Cloud Storage Space"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Used: 1 GB，Total: 15 GB"),
                        LinearProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          value: 1 / 15,
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userCubit == null && mounted) {
      setState(() {
        userCubit = context.read<UserCubit>();
      });
    }

    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          foregroundColor: mainColor,
          elevation: 0,
        ),
        body: Column(children: [
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
                    margin: EdgeInsets.only(left: 20, bottom: 20),
                    child: _buildUserInfo(Setting.userName)),
              ),
            ],
          ),
          _buildSettingsAfterLogin(), // 登入后才可显示
          // userCubit!.isLogin() ? _buildSettingsAfterLogin() : Container(),
          _buildSettingCard([
            SettingSelection(
              icon: Icons.settings,
              title: Text("Settings"),
              onPressed: () {},
              iconColor: Color(0xff8ea2b1),
            ),
            SettingSelection(
              icon: Icons.error,
              title: Text("About"),
              onPressed: () {},
              iconColor: Color(0xff5ca5eb),
            ),
            SettingSelection(
              icon: Icons.help,
              title: Text("Help and Feedback"),
              onPressed: () {},
              iconColor: Color(0xff68cdc3),
            ),
          ]),
          ElevatedButton(
            // 登入后才可显示
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width - 40, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () {},
            child: Text("Log Out"),
          )
        ]));
  }
}

class SettingSelection extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final void Function() onPressed;
  final Color iconColor;

  const SettingSelection(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onPressed,
      this.iconColor = Colors.black})
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
              color: iconColor,
            ),
            flex: 3,
          ),
          Expanded(
              flex: 16,
              child: ListTile(
                title: title,
              ))
        ],
      ),
    );
  }
}

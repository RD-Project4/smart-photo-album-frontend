import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:provider/src/provider.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
import 'package:smart_album/bloc/user/UserState.dart';
import 'package:smart_album/pages/Tabs.dart';

class Setting extends StatefulWidget {
  // final arguments;
  static int state = 4;

  // static var userId = '';
  // static var userEmail = '';
  // static var userName = '';
  // static var session = '';
  // static var userAccount = '';

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

  /// 用户栏
  Widget _buildUserInfo() {
    return BlocBuilder<UserCubit, UserState>(
        builder: (context, state) => state.user == null
            ? GestureDetector(
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                AssetImage('assets/images/default_avatar.png'),
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
        )
            : Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage:
              AssetImage("assets/images/default_avatar.png"),
            ),
            Expanded(
                child: ListTile(
                  title: Text("${state.user!.userName}"),
                  subtitle: Text("${state.user!.userEmail}"),
                ))
          ],
        ));
  }

  /// 登陆后显示的组件
  Widget _buildSettingsAfterLogin() {
    return _buildSettingCard(
      [
        SettingSelection(
          icon: Icons.group,
          title: Text("My Friends"),
          onPressed: () {
            Navigator.pushNamed(context, '/friends');
          },
          iconColor: Colors.indigo,
        ),
        SettingSelection(
          icon: Icons.favorite,
          title: Text("My Favorites"),
          onPressed: () {
            Navigator.pushNamed(context, '/favorite');
          },
          iconColor: Colors.red,
        ),
        SettingSelection(
          icon: Icons.share,
          title: Text("My Share"),
          onPressed: () {
            // if (context.read<UserCubit>().isLogin())
              Navigator.pushNamed(context, '/manage-share');
            // else
            //   showToast("Please login first");
          },
          iconColor: Colors.green,
        ),
        SettingSelection(
          icon: Icons.delete_rounded,
          title: Text("Trash bin"),
          onPressed: () {
            Navigator.pushNamed(context, '/trashbin');
          },
          iconColor: Colors.grey,
        ),
        SettingSelection(
          icon: Icons.cloud_rounded,
          title: Text('Backup manager'),
          onPressed: () {
            if (context.read<UserCubit>().isLogin())
              Navigator.pushNamed(context, '/uploadList');
            else
              showToast("Please login first");
          },
          iconColor: Colors.blue,
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
                    child: _buildUserInfo()),
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
          BlocBuilder<UserCubit, UserState>(
              builder: (context, state) => state.user != null
                  ? ElevatedButton(
                // 登入后才可显示
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width - 40, 50)),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.red)),
                onPressed: () {
                  context.read<UserCubit>().logout();
                  showToast("Log out");
                },
                child: Text("Log Out"),
              )
                  : Container())
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
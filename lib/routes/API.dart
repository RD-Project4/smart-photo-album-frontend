import 'package:flutter/material.dart';
import 'package:smart_album/pages/tabs/Setting.dart';
import 'package:smart_album/widgets/TabsDrawer.dart';
import 'package:smart_album/widgets/user/LoginForm.dart';
import '../CatagoryPage.dart';
import '../HomePage.dart';

import 'package:smart_album/util/Global.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class API extends StatefulWidget {
  API({Key? key}) : super(key: key);

  @override
  State<API> createState() => _APIState();
  @override
  void initState() {
    _APIState().showuser();
  }
}

class _APIState extends State<API> {
  var userId;
  var userAccount = '';
  var userName = '';
  var userEmail = '';
  var userProfile = '';
  var userPhone = '';

  var _status = 4;
  var _msg = '';
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  showuser() async {
    print('Tabs posting data');
    print(Setting.userAccount);
    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/showuser.do');

    var response =
        await http.post(apiurl, body: {"userAccount": Setting.userAccount});
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
      this.userId = jsonDecode(response.body)["data"]["userId"];
      this.userAccount = jsonDecode(response.body)["data"]["userAccount"];
      this.userName = jsonDecode(response.body)["data"]["userName"];
      this.userEmail = jsonDecode(response.body)["data"]["userEmail"];
      this.userProfile = jsonDecode(response.body)["data"]["userProfile"];
      this.userPhone = jsonDecode(response.body)["data"]["userPhone"];

      Setting.userId = jsonDecode(response.body)["data"]["userId"];
      Setting.userEmail = jsonDecode(response.body)["data"]["userEmail"];
    });
  }
}

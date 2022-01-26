import 'package:flutter/material.dart';
import 'package:smart_album/res/listData.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool flag = false;
  IconData changeIcon = Icons.arrow_drop_up_outlined;
  int _status = 4;
  String _msg = '';
  postData() async {
    print('posting data');

    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/logout.do');

    var response =
        await http.post(apiurl, body: {"userAccount": "administrator"});
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
    });
    if (this._status == 0) {
      print('jump to setting');
      Navigator.of(context).pushReplacementNamed('/');
    }
    print(_status);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: listData.map((value) {
        return Column(
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
                  child: ListTile(
                    leading: CircleAvatar(
                      //专门用来处理头像
                      backgroundImage: NetworkImage(value['imageUrl']),
                    ),
                    title: Text(value['title']),
                    subtitle: Text(
                      value['description'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: RaisedButton.icon(
                      elevation: 0,
                      color: Colors.white,
                      shape:
                          CircleBorder(side: BorderSide(color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          flag = !flag;
                          if (flag) {
                            this.changeIcon = Icons.arrow_drop_down_outlined;
                          } else {
                            this.changeIcon = Icons.arrow_drop_up_outlined;
                          }
                        });
                      },
                      icon: Icon(this.changeIcon),
                      label: Text(''),
                    ))
              ],
            ),
            RaisedButton(
              color: Colors.white,
              elevation: 0,
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Row(
                children: [
                  Expanded(
                    child: Icon(Icons.group_add),
                    flex: 1,
                  ),
                  Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text("Add Other Accounts"),
                      ))
                ],
              ),
            ),
            RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: () {
                postData();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Icon(Icons.app_blocking_rounded),
                    flex: 1,
                  ),
                  Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text(
                          "Quit Your Account",
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ))
                ],
              ),
            ),

            // RaisedButton(
            //   elevation: 0,
            //   color: Colors.white,
            //   onPressed: () {},
            //   child: Text("Manage your account"),
            // ),
            RaisedButton(
              elevation: 0,
              color: Colors.white,
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
            RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: () {},
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.phone_iphone),
                  ),
                  Expanded(
                      flex: 4,
                      child: ListTile(
                        title:
                            Text("400 items can be deleted from this device"),
                      ))
                ],
              ),
            ),
            RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: () {},
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.health_and_safety_outlined),
                  ),
                  Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text("Your data in the album"),
                      ))
                ],
              ),
            ),
            RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: () {},
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.help),
                  ),
                  Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text("Help and Feedback"),
                      ))
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

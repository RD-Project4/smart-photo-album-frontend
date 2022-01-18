import 'package:flutter/material.dart';
import 'package:smart_album/res/listData.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool flag = false;
  IconData changeIcon = Icons.arrow_drop_up_outlined;
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

            Row(
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
            Row(
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
            SizedBox(
              height: 10,
            ),

            RaisedButton(
              onPressed: () {},
              child: Text("Manage your account"),
            ),
            Card(
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
            Card(
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
            Card(
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
            Card(
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

import 'package:azlistview/azlistview.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:smart_album/widgets/GroupedView.dart';
import 'package:smart_album/widgets/ListedPhoto.dart';

class Friends extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  var friends = <FriendInfo>[
    FriendInfo(name: 'dsad'),
    FriendInfo(name: 'fad'),
    FriendInfo(name: 'awqerfdw'),
    FriendInfo(name: 'qwe'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Friends',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: AzListView(
          data: friends,
          itemCount: friends.length,
          itemBuilder: (context, index) {
            FriendInfo model = friends[index];
            return _buildListItem(model);
          },
        ));
  }

  Widget _buildListItem(FriendInfo model) {
    return Row(
      children: [Text(model.name)],
    );
  }
}

class FriendInfo extends ISuspensionBean {
  final String name;

  FriendInfo({required this.name});

  @override
  String getSuspensionTag() {
    return name;
  }
}

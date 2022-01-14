import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_album/res/listData.dart';

void main() => runApp(MyApp());

//图文布局、card、aspectratio、处理头像
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter'),
        ),
        body: LayoutDemo(),
      ),
    );
  }
}

class LayoutDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: listData.map((value) {
        return Card(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              AspectRatio(
                //Aspectratio
                aspectRatio: 20 / 9,
                child: Image.network(
                  value['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
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
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}

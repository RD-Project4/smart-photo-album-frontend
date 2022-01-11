import 'package:flutter/material.dart';
import 'package:multiutillib/utils/ui_helpers.dart';

class list extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
      ],








      // padding: EdgeInsets.all(10),
      // children: <Widget>[
      //   Image.network('src'),
      //   Container(
      //     height: 10,
      //   ),
      //   Image.network('src'),
      //   Image.network('src'),
      //   Image.network('src'),
      //   Image.network('src'),
      //   Image.network('src'),

        // ListTile(
        //   leading: Icon(
        //     Icons.accessible_forward_sharp,
        //     color: Colors.amber[900],
        //   ),
        //   title: Text(
        //     'data',
        //     style: TextStyle(fontSize: 24),
        //   ),
        //   subtitle: Text('ddddd'),
        //   trailing: Icon(
        //     Icons.adb_outlined,
        //     color: Colors.blueAccent[900],
        //   ),
        // ),
        // ListTile(
        //   title: Text('data'),
        //   subtitle: Text('ddddd'),
        // ),
        // ListTile(
        //   title: Text('data'),
        //   subtitle: Text('ddddd'),
        // ),
        // ListTile(
        //   title: Text('data'),
        //   subtitle: Text('ddddd'),
        // ),
        // ListTile(
        //   title: Text('data'),
        //   subtitle: Text('ddddd'),
        // ),
        // ListTile(
        //   title: Text('data'),
        //   subtitle: Text('ddddd'),
        // ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_album/res/listData.dart';

import 'list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FlutterDemo'),
        ),
        body: LayoutDemo(),
      ),
    );
  }
}

class LayoutDemo extends StatelessWidget {
  // Widget _getListData(context, index) {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Image.network(listData[index]['imageUrl']),
  //         SizedBox(height: 12),
  //         Text(
  //           listData[index]['title'],
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 10),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        IconContainer(
          Icons.search,
          color: Colors.blue,
        ),
        IconContainer(
          Icons.home,
          color: Colors.red,
        ),
        IconContainer(
          Icons.people,
          color: Colors.green,
        ),
        IconContainer(
          Icons.car_rental,
          color: Colors.purple,
        )
      ],
    );
  }
}

class IconContainer extends StatelessWidget {
  double size;
  Color color;
  IconData icon;

  IconContainer(this.icon, {this.color = Colors.red, this.size = 32.0}) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 800.0,
      width: 400.0,
      color: Colors.pink,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconContainer(
            Icons.search,
            color: Colors.blue,
          ),
          IconContainer(
            Icons.home,
            color: Colors.red,
          ),
          IconContainer(
            Icons.people,
            color: Colors.green,
          ),
          // IconContainer(
          //   Icons.car_rental,
          //   color: Colors.purple,
          // )
        ],
      ),
    );
  }
}

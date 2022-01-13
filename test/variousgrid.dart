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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              height: 180,
              color: Colors.pink,
              child: Text('hello fkmog'),
            ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 180,
                child: Image.network(
                  'https://www.itying.com/images/flutter/1.png',
                  fit: BoxFit.cover,
                ),
              ),
              flex: 2,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 180,
                child: ListView(
                  children: [
                    Container(
                      height: 85,
                      child: Image.network(
                        'https://www.itying.com/images/flutter/2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 85,
                      child: Image.network(
                        'https://www.itying.com/images/flutter/3.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
              flex: 1,
            ),
          ],
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

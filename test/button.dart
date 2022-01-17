import 'package:flutter/material.dart';

void main() => runApp(MyApp());

//点击按钮动态新增数据
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List list = [];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: this.list.map((value) {
            return ListTile(
              title: Text(value),
            );
          }).toList(),
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              this.list.add('新增数据1');
            });
          },
          child: Text('按钮'),
        )
      ],
    );
  }
}

// class HomePage extends StatefulWidget {
//   HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int countNum = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Chip(label: Text('你好')),
//         RaisedButton(
//           onPressed: () {
//             this.countNum++;
//             print(this.countNum);
//           },
//           child: Text('${this.countNum}'),
//         )
//       ],
//     );
//   }
// }

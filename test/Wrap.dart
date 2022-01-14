import 'package:flutter/material.dart';

import 'MyButton.dart';

void main() => runApp(MyApp());

//流式布局，多种标签
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
    return Wrap(
      children: [
        MyButton('Gravity Fall'),
        MyButton('Rick and Morty'),
        MyButton('Gambull'),
        MyButton('Ultra Man'),
        MyButton('Kongfu Panda'),
        MyButton('King order'),
        MyButton('Darkness'),
        MyButton('Devision'),
      ],
    );
  }
}

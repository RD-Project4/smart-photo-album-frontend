import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;

  const MyButton(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      child: Text(this.text),
      textColor: Theme.of(context).accentColor,
      onPressed: () {},
    );
  }
}

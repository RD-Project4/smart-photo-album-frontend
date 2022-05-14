import 'package:flutter/material.dart';

// TODO
class LoadingCircle extends StatelessWidget {
  const LoadingCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

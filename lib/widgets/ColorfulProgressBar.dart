import 'package:flutter/material.dart';
import 'package:rainbow_color/rainbow_color.dart';

class ColorfulProgressBar extends StatefulWidget {
  ColorfulProgressBar({Key? key}) : super(key: key);

  @override
  State<ColorfulProgressBar> createState() => _ColorfulProgressBarState();
}

class _ColorfulProgressBarState extends State<ColorfulProgressBar>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: controller.drive(
          RainbowColorTween([
            Colors.blueAccent,
            Colors.redAccent,
            Colors.yellowAccent,
            Colors.greenAccent
          ]),
        ));
  }
}

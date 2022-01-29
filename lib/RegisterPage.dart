import 'package:flutter/material.dart';
import 'package:smart_album/widgets/HiddenAppbar.dart';

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HiddenAppbar(),
      body: Center(
        child: Stepper(type: StepperType.horizontal, steps: <Step>[
          Step(title: Text(''), content: Container()),
          Step(title: Text(''), content: Container()),
          Step(title: Text(''), content: Container())
        ]),
      ),
    );
  }
}

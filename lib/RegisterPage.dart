import 'package:flutter/material.dart';
import 'package:smart_album/widgets/HiddenAppbar.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HiddenAppbar(),
        body: Center(
            child: Stepper(
                currentStep: _index,
                type: StepperType.horizontal,
                onStepCancel: () {
                  if (_index > 0) {
                    setState(() {
                      _index -= 1;
                    });
                  }
                },
                onStepContinue: () {
                  if (_index < 2) {
                    setState(() {
                      _index += 1;
                    });
                  }
                },
                steps: <Step>[
              Step(
                  title: Text(''),
                  isActive: _index >= 0,
                  content: Container(
                      child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email'),
                  ))),
              Step(
                  title: Text(''),
                  isActive: _index >= 1,
                  content: Container(
                      child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your code'),
                  ))),
              Step(
                  title: Text(''),
                  isActive: _index >= 2,
                  content: Container(
                      child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your name'),
                  )))
            ])));
  }
}

import 'package:flutter/material.dart';
import 'package:smart_album/pages/Tabs.dart';
import '../pages/Tabs.dart';

class RegisterThirdPage extends StatelessWidget {
  const RegisterThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step3-Reconfirm"),
        backgroundColor: Colors.cyanAccent[900],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text("Rewirte your password again"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      //返回根目录
                      Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (context) => new Tabs(
                                    index: 2,
                                  )),
                          (route) => route == null);
                    },
                    child: Text('Done!'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

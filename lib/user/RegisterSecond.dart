import 'package:flutter/material.dart';

@Deprecated('使用RegisterPage')
class RegisterSecondPage extends StatelessWidget {
  const RegisterSecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step2-Passward"),
        backgroundColor: Colors.cyanAccent[900],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text("Enter your password"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/registerthird');
                      // Navigator.of(context).pushReplacementNamed('/registerthird');
                    },
                    child: Text('Next!'),
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

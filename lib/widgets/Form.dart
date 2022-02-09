import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Create a Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late String account;
  late String password;

  var _status = 4;
  var _msg = '';

  getData() async {
    print('getting data');
    var apiurl = Uri.parse(
        'http://124.223.68.12:8233/smartAlbum/login.do?userAccount=administrator&userPwd=123456');
    var response = await http.get(apiurl);

    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
    });
    if (this._status == 5) {
      print('jump to setting');
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      print('jump to login');
      Navigator.of(context).pushReplacementNamed('/loginPage');
    }
    print(_status);
  }

  postData() async {
    print('posting data');
    print(this.account);
    print(this.password);
    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/login.do');

    var response = await http.post(apiurl,
        body: {"userAccount": this.account, "userPwd": this.password});
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
    });
    if (this._status == 5) {
      print('jump to setting');
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      print('jump to login');
    }
    print(_status);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'E-mail'),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                this.account = value;
              });
            },
            onSaved: (value) {
              account = value!;
            },
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Password'),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                this.password = value;
              });
            },
            onSaved: (value) {
              password = value!;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                print('you have pressed');
                postData();
                // Validate returns true if the form is valid, or false otherwise.
                // if (_formKey.currentState!.validate()) {
                //   _formKey.currentState!.save();
                //   if (account == "test@test.com" && password == "123456") {
                //     // If the form is valid, display a snackbar. In the real world,
                //     // you'd often call a server or save the information in a database.
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Processing Data')),
                //     );
                //     Timer(const Duration(seconds: 1), () {
                //       Navigator.maybePop(context);
                //     });
                //   } else
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //           backgroundColor: Colors.redAccent,
                //           content: Text('Verification error')),
                //     );
                // }
              },
              child: const Text('Login'),
            ),
          ),
          Container(
            child: ListTile(
              title: Text(
                "${this._msg}",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

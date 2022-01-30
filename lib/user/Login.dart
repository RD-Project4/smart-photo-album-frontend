// import 'package:flutter/material.dart';
//
// class LoginPage extends StatelessWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Login & Register"),
//         ),
//         body: Container(
//           color: Colors.blueGrey[100],
//           margin: EdgeInsets.all(5),
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 40,
//                 ),
//                 Text(
//                   "WELCOME",
//                   style: TextStyle(
//                     fontSize: 70,
//                     fontFamily: "Times New Roman",
//                     // backgroundColor: Colors.amber[50],
//                   ),
//                 ),
//                 Divider(),
//                 Text(
//                   "TO",
//                   style: TextStyle(
//                     fontSize: 75,
//                     fontFamily: "Times New Roman",
//                     // backgroundColor: Colors.amber[50],
//                   ),
//                 ),
//                 Divider(),
//                 Text(
//                   "SMART",
//                   style: TextStyle(
//                     fontSize: 75,
//                     fontFamily: "Times New Roman",
//                     // backgroundColor: Colors.amber[50],
//                   ),
//                 ),
//                 Divider(),
//                 Text(
//                   "ALBUM",
//                   style: TextStyle(
//                     fontSize: 75,
//                     fontFamily: "Times New Roman",
//                     // backgroundColor: Colors.amber[50],
//                   ),
//                 ),
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                         flex: 2,
//                         child: Container(
//                           margin: EdgeInsets.all(20),
//                           height: 50,
//                           child: OutlineButton(
//                             onPressed: () {
//                               Navigator.of(context).pushNamed('/loginPage');
//                               // Navigator.of(context)
//                               //     .pushReplacementNamed('/loginPageOne');
//                             },
//                             child: Text('Login'),
//                           ),
//                         )),
//                     Divider(),
//                     Expanded(
//                         flex: 2,
//                         child: Container(
//                           margin: EdgeInsets.all(20),
//                           height: 50,
//                           child: OutlineButton(
//                             onPressed: () {
//                               Navigator.of(context).pushNamed('/registerfirst');
//                               // Navigator.of(context)
//                               //     .pushReplacementNamed('/registerfirst');
//                             },
//                             child: Text('Regist'),
//                           ),
//                         ))
//                   ],
//                 ),
//                 SizedBox(
//                   height: 80,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Icon(Icons.camera_alt_outlined),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Icon(Icons.photo_camera_back),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Icon(Icons.photo_camera_front),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }

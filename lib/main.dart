import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:smart_album/routes/Routes.dart';
import 'package:splashscreen/splashscreen.dart';

import 'ViewModel/PhotoViewModel.dart';
import 'database/ObjectStore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectStore.create();
  runApp(OKToast(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: onGenerateRoute,
        debugShowCheckedModeBanner: false,
        home: Splash());
  }
}

class Splash extends StatelessWidget {
  Future<String> loadFromFuture() async {
    await PhotoViewModel.refresh();
    return "/Home";
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        navigateAfterFuture: loadFromFuture(),
        useLoader: true,
        loadingTextPadding: EdgeInsets.all(0),
        loadingText: Text("Processing images..."),
        title: Text(
          'Smart Album',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset('images/logo_white_bg.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.blueAccent);
  }
}

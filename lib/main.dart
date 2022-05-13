import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
import 'package:smart_album/routes/Routes.dart';
import 'package:splashscreen/splashscreen.dart';

import 'database/ObjectStore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectStore.create();
  runApp(OKToast(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => PhotoCubit()),
          BlocProvider(create: (context) => UserCubit())
        ],
        child: MaterialApp(
            onGenerateRoute: onGenerateRoute,
            debugShowCheckedModeBanner: false,
            home: Splash()));
  }
}

class Splash extends StatelessWidget {
  Future<String> loadFromFuture(BuildContext context) async {
    await context.read<PhotoCubit>().refresh(context);
    return "/Home";
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        navigateAfterFuture: loadFromFuture(context),
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

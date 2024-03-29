// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hrc_project/login_page/auth/auth_page.dart';
import 'login_page/pages/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // MaterialApp(
  //   initialRoute: '/',
  //   routes: {
  //     '/': (BuildContext context) => StartPageWidget(),
  //     '/second': (BuildContext context) => AuthPage(),
  //   },
  // );

  //  screen rotation lock
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

Future hideSmartPhoneBar() async {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //  OS navigation bar hide
    hideSmartPhoneBar();
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => StartPageWidget(),
        '/second': (BuildContext context) => AuthPage(),
      },
      theme: ThemeData(
        fontFamily: 'JostMain',
      ),
      debugShowCheckedModeBanner: false,
      //home: StartPageWidget(),
    );
  }
}

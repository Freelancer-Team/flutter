import 'package:flutter/material.dart';
import 'package:freelancer_flutter/pages/home.dart';
import 'package:freelancer_flutter/pages/profile.dart';
import 'package:freelancer_flutter/pages/ProjDetails.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',

      routes: {
//        '/': (context) => Splash(),
          '/home' : (context) => RecomendedPage(),
          '/projdetails' : (context) => ProjDetails(),
//        '/login' : (context) => Login(),
//        '/signup' : (context) => Signup(),
//        '/category' : (context) => Category(),
          '/profile' : (context) => ProfilePage(),
      },
    );
  }
}

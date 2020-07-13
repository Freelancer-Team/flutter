import 'package:flutter/material.dart';
import 'package:freelancer_flutter/pages/apply.dart';
import 'package:freelancer_flutter/pages/home.dart';
import 'package:freelancer_flutter/pages/publish.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
//        '/': (context) => Splash(),
        '/home': (context) => RecomendedPage(),
//        '/login' : (context) => Login(),
//        '/signup' : (context) => Signup(),
//        '/category' : (context) => Category(),
        '/publish': (context) => PublishPage(),
        '/apply':(context)=>ApplyPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:freelancer_flutter/pages/apply.dart';
import 'package:freelancer_flutter/pages/home.dart';
import 'package:freelancer_flutter/pages/publish.dart';
import 'package:freelancer_flutter/pages/profile.dart';
import 'package:freelancer_flutter/pages/ProjDetails.dart';
import 'package:freelancer_flutter/pages/login.dart';
import 'package:freelancer_flutter/pages/signup.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signup',

      routes: {
//        '/': (context) => Splash(),
          '/home' : (context) => RecomendedPage(),
          '/projdetails' : (context) => ProjDetails(),
//        '/login' : (context) => LoginScreen(),
        '/signup' : (context) => signUpScreen(),
//        '/category' : (context) => Category(),
          '/profile' : (context) => ProfilePage(),
        '/publish': (context) => PublishPage(),
        '/apply':(context)=>ApplyPage(),
      },
    );
  }
}

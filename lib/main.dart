import 'package:flutter/material.dart';
import 'package:freelancer_flutter/pages/apply.dart';
import 'package:freelancer_flutter/pages/home.dart';
import 'package:freelancer_flutter/pages/publish.dart';
import 'package:freelancer_flutter/pages/profile.dart';
import 'package:freelancer_flutter/pages/ProjDetails.dart';
import 'package:freelancer_flutter/pages/login.dart';
import 'package:freelancer_flutter/pages/signup.dart';
import 'package:freelancer_flutter/pages/jobList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
//        '/': (context) => Splash(),
        '/home': (context) => HomePage(),
//        '/projdetails': (context) => ProjDetails(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => signUpScreen(),
//        '/category' : (context) => Category(),
        '/profile': (context) => ProfilePage(),
        '/publish': (context) => PublishPage(),
        '/jobList':(context) => JobListPage(),
//        '/apply': (context) => HomePage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freelancer_flutter/theme/app_theme.dart';
import 'package:freelancer_flutter/component/custom_drawer/navigation_home_screen.dart';
import 'package:freelancer_flutter/pages/login.dart';
import 'package:freelancer_flutter/pages/signup.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Freelancer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => NavigationHomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignUpScreen(),
      },
    );
  }
}

import 'package:freelancer_flutter/pages/feedback_screen.dart';
import 'package:freelancer_flutter/pages/home.dart';
import 'package:freelancer_flutter/pages/onesJobManage.dart';
import 'package:freelancer_flutter/pages/profile.dart';
import 'package:freelancer_flutter/theme/app_theme.dart';
import 'package:freelancer_flutter/component/custom_drawer/drawer_user_controller.dart';
import 'package:freelancer_flutter/component/custom_drawer/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_flutter/pages/admin.dart';
import 'package:freelancer_flutter/pages/jobList.dart';

class NavigationHomeScreen extends StatefulWidget {
  NavigationHomeScreen({
    this.drawerIndex = DrawerIndex.HOME
  });

  final DrawerIndex drawerIndex;

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = widget.drawerIndex;
    setIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width > 1080 ? 300 : MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void setIndex() {
    if (drawerIndex == DrawerIndex.HOME) {
        screenView = HomePage();
    } else if (drawerIndex == DrawerIndex.Finder) {
        screenView = JobListPage();
    } else if (drawerIndex == DrawerIndex.Project) {
        screenView = OnesJobManagePage();
    } else if (drawerIndex == DrawerIndex.Contact) {
        screenView = FeedbackScreen();
    } else if (drawerIndex == DrawerIndex.Manage) {
        screenView = AdminPage();
    } else {
      //do in your way......
    }
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = HomePage();
        });
      } else if (drawerIndex == DrawerIndex.Finder) {
        setState(() {
          screenView = JobListPage();
        });
      } else if (drawerIndex == DrawerIndex.Project) {
        setState(() {
          screenView = OnesJobManagePage();
        });
      } else if (drawerIndex == DrawerIndex.Contact) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Manage) {
        setState(() {
          screenView = AdminPage();
        });
      } else {
        //do in your way......
      }
    }
  }
}

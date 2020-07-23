import 'package:flutter/material.dart';
import 'package:freelancer_flutter/utilities/Account.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}
class _MyDrawerState extends State<MyDrawer> {
  String username;

  String email;

  bool isLog = false;
  String icon = 'assets/unlogin.jpg';

  getUser() async {
    String usern = await StorageUtil.getStringItem("username");
    String e = await StorageUtil.getStringItem("email");
    if (usern != null && e != null) {
      setState(() {
        username = usern;
        email = e;
        icon = 'assets/dragon.jpg';
        isLog = true;
      });
    } else
      setState(() {
        username = 'not login';
        email = '';
        isLog = false;
      });
    print(username);
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Widget UserInfo() {
    // TODO: implement build
    return Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: DrawerHeader(
          child: Row(children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('$icon'),
              radius: 50.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      '$username',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      if (!isLog) Navigator.pushNamed(context, '/login');
                    },
                  ),
                  Text(
                    '$email',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  )
                ],
              ),
            ),
          ]),
          decoration: BoxDecoration(
            color: Colors.blue[900],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserInfo(),
          ListTile(
            title: Text(
              "Home",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.home,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          Divider(
            height: 15.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text(
              "My Profile",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.person,
              color: Colors.black,
            ),
            onTap: () {
              !isLog?Navigator.pushNamed(context, '/login'):Navigator.pushNamed(context, '/profile');
            },
          ),
          Divider(
            height: 15.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text(
              "Dashboard",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.dashboard,
              color: Colors.black,
            ),
            onTap: () {},
          ),
          Divider(
            height: 12.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text(
              "Feedback",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.rss_feed,
              color: Colors.black,
            ),
            onTap: () {},
          ),
          Divider(
            height: 12.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text(
              "Find a Job",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onTap: () {Navigator.pushNamed(context, '/jobList');},
          ),
          Divider(
            height: 10.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text(
              !isLog?"Login":"Logout",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.lock_outline,
              color: Colors.black,
            ),
            onTap: () {
              Account.delUserInfo();
              !isLog?Navigator.pushNamed(context, '/login'):Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}

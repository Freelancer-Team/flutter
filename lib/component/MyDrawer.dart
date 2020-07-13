import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: DrawerHeader(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/jene.jpg'),
                    radius: 50.0,
                  ),
                  SizedBox(width: 10.0,),

                  Container(
                    padding: EdgeInsets.only(top: 40),
                    child: Column(
                      children: <Widget>[
                        Text('Ken Jessie',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                          ),
                        ),
                        Text('Bead Making',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white
                          ),)
                      ],
                    ),
                  ),
                ],
              ),

              decoration: BoxDecoration(

                color: Colors.blue[900],

              ),

            ),
          ),
          ListTile(
            title: Text("Home",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            leading: Icon(Icons.home, color: Colors.black,),
            onTap: () {},
          ),
          Divider(
            height: 15.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text("My Profile",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),),
            leading: Icon(Icons.person, color: Colors.black,),
            onTap: () {Navigator.pushNamed(context, '/profile');},
          ),
          Divider(
            height: 15.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text("Dashboard",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),),
            leading: Icon(Icons.dashboard, color: Colors.black,),
            onTap: () {},
          ),
          Divider(
            height: 12.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text("Feedback",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),),
            leading: Icon(Icons.rss_feed, color: Colors.black,),
            onTap: () {},
          ),
          Divider(
            height: 12.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text("Find a Job",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),),
            leading: Icon(Icons.search, color: Colors.black,),
            onTap: () {},
          ),
          Divider(
            height: 10.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text("Logout",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),),
            leading: Icon(Icons.lock_outline, color: Colors.black,),
            onTap: () {
              Navigator.pop(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}

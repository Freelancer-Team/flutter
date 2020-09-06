import 'hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:date_format/date_format.dart';

class UserAdminItem extends StatelessWidget {
  const UserAdminItem(
      {Key key,
        this.userData,
        this.animationController,
        this.animation,
        this.callback,
        this.toggleCallback,
        this.isLarge
      })
      : super(key: key);

  final VoidCallback callback;
  final Function(int) toggleCallback;
  final User userData;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  callback();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              color: HotelAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Offstage(
                                                offstage: isLarge,
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                                  child: RoleCard(role: userData.role, isLarge: false,)
                                                )
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(top: 8),
                                                  child: CircleAvatar(
                                                    backgroundImage: NetworkImage(userData.userIcon),
                                                    radius: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 15, top: 4),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                        Row(
                                                          children: [
                                                            Text(
                                                              userData.name,
                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 22,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 10, right: 10),
                                                              child: getGenderIcon(),
                                                            ),
                                                            Offstage(
                                                              offstage: !isLarge,
                                                              child: RoleCard(role: userData.role, isLarge: true,),
                                                            )
                                                          ],
                                                        ),

                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Chip(
                                                            label: Text(userData.email),
                                                            avatar: CircleAvatar(
                                                              child: Icon(Icons.email, size: 20,),
                                                            ),
                                                            labelPadding: EdgeInsets.only(left: 8, right: 10),
                                                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                          ),
                                                          Offstage(
                                                            offstage: !isLarge,
                                                            child: Container(
                                                              margin: EdgeInsets.only(left: 15),
                                                              child: Chip(
                                                                label: Text(userData.phone),
                                                                avatar: CircleAvatar(
                                                                  child: Icon(Icons.phone, size: 20,),
                                                                ),
                                                                labelPadding: EdgeInsets.only(left: 8, right: 10),
                                                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 2),
                                              child: Text(
                                                userData.description,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey
                                                        .withOpacity(0.8)),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 4),
                                              child: Wrap(
                                                children: userData.skills.map((skill) => Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
                                                  margin: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    color: Colors.black54,
                                                  ),
                                                  child: Text(skill,style: TextStyle(height: 1,fontSize: 14, color: Colors.white.withOpacity(0.8)),),
                                                )).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: SizedBox(
                            height: 30,
                            child: getToggleSwitch(),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getGenderIcon() {
    if(userData.gender == "M") return Icon(FontAwesomeIcons.mars, size: 22, color: Colors.blue,);
    else return Icon(FontAwesomeIcons.venus, size: 22, color: Colors.pink,);
  }

  Widget getToggleSwitch() {
    if(userData.role == 1)
      return AbsorbPointer(
        child: ToggleSwitch(
          minWidth: 90.0,
          initialLabelIndex: 0,
          cornerRadius: 16.0,
          activeFgColor: Colors.white,
          activeBgColor: Colors.grey.withOpacity(0.5),
          inactiveBgColor: Colors.grey.withOpacity(0.5),
          inactiveFgColor: Colors.white,
          labels: ['正常', '禁用'],
          activeBgColors: [Colors.blue.withOpacity(0.5), Colors.pink.withOpacity(0.5)],
        ),
      );
    else if(userData.role == 0)
      return SizedBox(
        child: ToggleSwitch(
          minWidth: 90.0,
          initialLabelIndex: 0,
          cornerRadius: 16.0,
          activeFgColor: Colors.white,
          activeBgColor: Colors.grey,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          labels: ['正常', '禁用'],
          activeBgColors: [Colors.blue, Colors.pink],
          onToggle: (index) {
            toggleCallback(index);
          },
        ),
      );
    else if(userData.role == -1)
      return Container(
        child: ToggleSwitch(
          minWidth: 90.0,
          initialLabelIndex: 1,
          cornerRadius: 16.0,
          activeFgColor: Colors.white,
          activeBgColor: Colors.grey,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          labels: ['正常', '禁用'],
          activeBgColors: [Colors.blue, Colors.pink],
          onToggle: (index) {
            toggleCallback(index);
          },
        ),
      );
    else return ToggleSwitch(
        minWidth: 90.0,
        initialLabelIndex: -1,
        cornerRadius: 16.0,
        activeFgColor: Colors.white,
        activeBgColor: Colors.grey,
        inactiveBgColor: Colors.grey,
        inactiveFgColor: Colors.white,
        labels: ['正常', '禁用'],
        activeBgColors: [Colors.blue, Colors.pink],
        onToggle: (index) {
          toggleCallback(index);
        },
      );
  }
}


class User {
  User(
      this.userId,
      this.name,
      this.gender,
      this.email,
      this.phone,
      this.description,
      this.skills,
      this.role,
      this.userIcon
      );
  final int userId;
  final String name;
  final String gender;
  final String email;
  final String phone;
  final String description;
  final List<String> skills;
  int role;
  final String userIcon;
}

class RoleCard extends StatelessWidget{
  const RoleCard({Key key, this.role, this.isLarge})
      : super(key: key);

  final int role;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    switch(role){
      case -2: {
        text = '待核验';
        color = Colors.orange.withOpacity(0.6);
      }
      break;
      case -1: {
        text = '已封禁';
        color = Colors.red.withOpacity(0.6);
      }
      break;
      case 0: {
        text = '已核验';
        color = Colors.green.withOpacity(0.6);
      }
      break;
      case 1: {
        text = '管理员';
        color = Colors.cyan.withOpacity(0.6);
      }
      break;
    }
    return Container(
      padding: isLarge ? EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0) : EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: color,
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 14,
            color: Colors.white
        ),
      ),
    );
  }
}

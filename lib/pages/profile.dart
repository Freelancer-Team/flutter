import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelancer_flutter/component/MyDrawer.dart';
import 'package:freelancer_flutter/component/SkillChooseModal.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    setState(() { // Causes the app to rebuild with the new _selectedChoice.
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('个人中心',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue[900],
            ),
          ),
          brightness: Brightness.light,
          actions: <Widget>[
            PopupMenuButton<Choice>( // overflow menu
              icon: Icon(Icons.dashboard),
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map<PopupMenuItem<Choice>>((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: new ListTile(
                      leading: Icon(choice.icon),
                      title: Text(choice.title),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        drawer: MyDrawer(),


      body: ChoiceCard(choice: _selectedChoice),
    );
  }
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: '个人信息', icon: Icons.account_circle),
  Choice(title: '我的项目', icon: Icons.assignment),
  Choice(title: '私信', icon: Icons.email),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({ Key key, this.choice }) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    if(choice.title == '个人信息') return UserInfo();
    else if(choice.title == '我的项目') return ProjectInfo();
    else return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0),
            Text(choice.title),
          ],
        ),
      ),
    );
  }
}


class UserInfo extends StatefulWidget {
  UserInfo({Key key}) : super(key: key);

  @override
  _UserInfoState createState() => new _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  //假数据在这里
  List<String> _skills = ["Java", "C++", "JavaScript", "Dart", "Python"];



  FlutterToast flutterToast;

  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("更新技能点成功"),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showSimpleDialog() {
    onSkillChange(var skills){
      setState(() {
        _skills = skills;
      });
      Navigator.pop(context);
      _showToast();
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
            title: Text('编辑您的专业技能'),
            // 这里传入一个选择器列表即可
            children: [
              SkillDialog(skillChoose: this._skills, onSkillChanged: onSkillChange,),
            ]
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> skillManageList = _skills.map((skill) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.lightGreenAccent,
      ),
      child: Text(skill,style: TextStyle(height: 1)),
    )).toList();
    skillManageList.add(Container(
      child: SizedOverflowBox(
        size: Size(32,32),
        alignment: Alignment.center,
        child: IconButton( // action button
          icon: new Icon(Icons.add_circle),
          padding: const EdgeInsets.all(0),
          onPressed: () { _showSimpleDialog(); },
        ),
      ),
    ));

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("个人信息"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image:AssetImage('assets/ProfileImage/userIcon.jpg'),
                  height: 128,
                  width: 128,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 128),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Username",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: "Courier",
                        ),
                      ),
                      Text("年龄"),
                      Text("性别"),
                      Text("邮箱"),
                      Text("电话"),
                      Text("地区")
                    ],
                  ),
                )
              ],
            ),
            Text("加入日期"),
            Text("技能点"),
            Wrap(
              children: skillManageList,
            ),
            Text("个人描述"),
          ]
        ),
      )

    );
  }
}

class ProjectInfo extends StatefulWidget {
  ProjectInfo({Key key}) : super(key: key);

  @override
  _ProjectInfoState createState() => new _ProjectInfoState();
}

class _ProjectInfoState extends State<ProjectInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListTile(
        leading: Icon(Icons.assignment),
        title: Text("我的项目"),
      ),
    );
  }
}

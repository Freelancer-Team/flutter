//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelancer_flutter/component/MyDrawer.dart';
import 'package:freelancer_flutter/component/SkillChooseModal.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:freelancer_flutter/utilities/Account.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:freelancer_flutter/component/ProjectTables.dart';
import 'package:freelancer_flutter/component/config.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    setState(() {
      // Causes the app to rebuild with the new _selectedChoice.
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '个人中心',
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
          PopupMenuButton<Choice>(
            // overflow menu
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
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: '个人信息', icon: Icons.account_circle),
  Choice(title: '我的项目', icon: Icons.assignment),
  Choice(title: '私信', icon: Icons.email),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    if (choice.title == '个人信息')
      return UserInfo();
    else if (choice.title == '我的项目')
      return ProjectInfo();
    else
      return Card(
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
  List<String> _skills =
      []; //= ["Java", "C++", "JavaScript", "Dart", "Python"];
  String token;
  String email, username, desc;
  String date, address, gender, tel;
  int uid, age;

  FlutterToast flutterToast;

  getToken() async {
    token = await StorageUtil.getStringItem('token');
    String email = await StorageUtil.getStringItem("email");
    String uname = await StorageUtil.getStringItem("username");
    String time = await StorageUtil.getStringItem("time");
    String add = await StorageUtil.getStringItem("address");
    String g = await StorageUtil.getStringItem("gender");
    String phone = await StorageUtil.getStringItem("phone");
    String des = await StorageUtil.getStringItem("desc");
    int userid = await StorageUtil.getIntItem("uid");
    int age = await StorageUtil.getIntItem("age");
    List<String> skills = await StorageUtil.getStringListItem("skills");

    if (email != null) {
      // 跳转到首页print(user);
//      print(user[0]);
      setState(() {
        this.email = email;
        uid = userid;
        username = uname;
        date = time;
        address = add;
        tel = phone;
        gender = g;
        desc = des;
        this.age = age;
        print(skills);
        if (skills != null) _skills = skills;
      });
    } else
      print('bbb');
  }

  @override
  void initState() {
    super.initState();
    getToken();
    flutterToast = FlutterToast(context);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black12,
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

  saveSkills(skills) async {
    try {
      String url = "${Url.url_prefix}/updateSkills?userId=" + uid.toString();
      print(url);print(skills);
      var res = await http.post(Uri.encodeFull(url),
          headers: {"content-type": "application/json","Authorization": "$token"},
          body:  json.encode(skills));
      var response = json.decode(res.body);
      if (response != null) {
        Account.saveUserSkill(response);
      }
    } catch (e) {
      print(e);
    }
  }

  _showSimpleDialog() {
    onSkillChange(var skills) {
      setState(() {
        _skills = skills;
      });
      saveSkills(skills);
      Navigator.pop(context);
      _showToast();
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(title: Text('编辑您的专业技能'),
                // 这里传入一个选择器列表即可
                children: [
                  SkillDialog(
                    skillChoose: this._skills,
                    onSkillChanged: onSkillChange,
                  ),
                ]));
  }

  @override
  Widget build(BuildContext context) {
//    getToken();
    List<Widget> skillManageList = _skills
        .map((skill) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Color(0xFF023E8A),
              ),
              child:
                  Text(skill, style: TextStyle(height: 1, color: Colors.white)),
            ))
        .toList();
    skillManageList.add(Container(
      child: SizedOverflowBox(
        size: Size(32, 32),
        alignment: Alignment.center,
        child: IconButton(
          // action button
          icon: new Icon(Icons.add_circle),
          padding: const EdgeInsets.all(0),
          onPressed: () {
            _showSimpleDialog();
          },
        ),
      ),
    ));

    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        new ListTile(
          leading: Icon(Icons.account_circle),
          title: Text("个人信息"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/ProfileImage/userIcon.jpg'),
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
                  Text(
                    "$username",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: "Courier",
                    ),
                  ),
                  Text("年龄：$age"),
                  Text("性别：$gender"),
                  Text("邮箱：$email"),
                  Text("电话：$tel"),
                  Text("地区：$address")
                ],
              ),
            )
          ],
        ),
        Text("加入日期：$date"),
        Text("技能点："),
        Wrap(
          children: skillManageList,
        ),
        Text("个人描述："),
        Text("$desc"),
      ]),
    ));
  }
}

class ProjectInfo extends StatefulWidget {
  ProjectInfo({Key key}) : super(key: key);

  @override
  _ProjectInfoState createState() => new _ProjectInfoState();
}

class _ProjectInfoState extends State<ProjectInfo> {
  String chooseView = 'employer';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.assessment),
                          title: Text("我的项目"),
                          contentPadding: EdgeInsets.only(left: 0.0),
                        ),
                      ),
                      ToggleSwitch(
                          minWidth: 90.0,
                          cornerRadius: 20,
                          activeBgColor: Colors.blue,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          labels: ['雇主', '雇员'],
                          icons: [Icons.language, Icons.group],
                          onToggle: (index) {
                            if(index == 1) setState(() {
                              chooseView = 'employee';
                            });
                            else setState(() {
                              chooseView = 'employer';
                            });
                          }),
                    ],
                  ),
                ),
                (chooseView == 'employer') ? EmployerView() : EmployeeView()
              ]
          ),
        )
    );
  }
}

class EmployerView extends StatefulWidget {
  @override
  _EmployerViewState createState() => _EmployerViewState();
}

class _EmployerViewState extends State<EmployerView> with SingleTickerProviderStateMixin {

  TabController mController;
  List<String> tabTitles;

  @override
  void initState() {
    super.initState();
    tabTitles = [
      "进行中",
      "已完成",
      "竞标中",
    ];
    mController = TabController(
      length: tabTitles.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          children: <Widget>[
            Container(
                height: 38.0,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    border: Border(bottom:BorderSide(width: 0.7,color: Colors.blue) )
                ),
                child: Row(
                  children: [
                    TabBar(
                      isScrollable: true,
                      //是否可以滚动
                      controller: mController,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Color(0xff666666),
                      labelStyle: TextStyle(fontSize: 16.0),
                      tabs: tabTitles.map((item) {
                        return Tab(
                          text: item,
                        );
                      }).toList(),
                    ),
                  ],
                )
            ),
            Expanded(
              child: TabBarView(
                controller: mController,
                children: tabTitles.map((item) {
                  if (item == "进行中")
                    return DataTableDemo(
                      columnNames: ["项目名称","雇员","佣金","截止日期","违约金"],
                      tableKind: "employerProceeding",
                    );
                  else if(item == "已完成")
                    return DataTableDemo(
                      columnNames: ["项目名称","雇员","佣金","完成日期","雇员评分"],
                      tableKind: "employerComplete",
                    );
//                  else if(item == "竞标中")
//                    return DataTableDemo(
//                      columnNames: ["项目名称","最低竞价","平均竞价","截止日期","状态"],
//                      tableKind: "employerBid",
//                    );
                  else return Text("竞标还没写");
                }).toList(),
              ),
            ),
          ],
        ));
  }
}

class EmployeeView extends StatefulWidget {
  @override
  _EmployeeViewState createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> with SingleTickerProviderStateMixin {

  TabController mController;
  List<String> tabTitles;

  @override
  void initState() {
    super.initState();
    tabTitles = [
      "进行中",
      "已完成",
      "竞标中",
    ];
    mController = TabController(
      length: tabTitles.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          children: <Widget>[
            Container(
                height: 38.0,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    border: Border(bottom:BorderSide(width: 0.7,color: Colors.blue) )
                ),
                child: Row(
                  children: [
                    TabBar(
                      isScrollable: true,
                      //是否可以滚动
                      controller: mController,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Color(0xff666666),
                      labelStyle: TextStyle(fontSize: 16.0),
                      tabs: tabTitles.map((item) {
                        return Tab(
                          text: item,
                        );
                      }).toList(),
                    ),
                  ],
                )
            ),
            Expanded(
              child: TabBarView(
                controller: mController,
                children: tabTitles.map((item) {
                  if (item == "进行中")
                    return DataTableDemo(
                      columnNames: ["项目名称","雇主","佣金","截止日期","违约金"],
                      tableKind: "employeeProceeding",
                    );
                  else if(item == "已完成")
                    return DataTableDemo(
                      columnNames: ["项目名称","雇主","佣金","完成日期","雇主评分"],
                      tableKind: "employeeComplete",
                    );
//                  else if(item == "竞标中")
//                    return DataTableDemo(
//                      columnNames: ["项目名称","最低竞价","平均竞价","截止日期","状态"],
//                      tableKind: "employerBid",
//                    );
                  else return Text("竞标还没写");
                }).toList(),
              ),
            ),
          ],
        ));
  }
}

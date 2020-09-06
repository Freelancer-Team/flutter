import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freelancer_flutter/component/PersonRateJobItem.dart';
import 'package:freelancer_flutter/component/hotel_app_theme.dart';
import 'package:freelancer_flutter/component/config.dart';
import 'package:freelancer_flutter/pages/onesJobManage.dart';
import 'package:freelancer_flutter/pages/person.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:freelancer_flutter/pages/ProjDetails.dart';
import 'package:freelancer_flutter/component/UserInfoEditModal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelancer_flutter/component/SkillChooseModal.dart';


//'个人资料'、'我的资料'统一入口
class UserInfoPage extends StatefulWidget{
  UserInfoPage({this.userId});

  final int userId;

  @override
  State<StatefulWidget> createState() {
    return new _UserInfoPageState();
  }
}

class _UserInfoPageState extends State<UserInfoPage>{
  bool isOneSelf = false;

  @override
  void initState() {
    super.initState();
    getUserIdentity();
  }

  getUserIdentity() async {
    int userId = await StorageUtil.getIntItem("uid");
    setState(() {
      isOneSelf = (userId == widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isOneSelf) return Profile(userId: widget.userId);
    else return Person(userId: widget.userId,);
  }
}

class Profile extends StatefulWidget{
  Profile({this.userId});

  final int userId;

  @override
  State<StatefulWidget> createState() {
    return new _ProfileState();
  }
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin{
  TabController _tabController;
  final List<Tab> tabs = <Tab>[
    new Tab(text: "雇主"),
    new Tab(text: "雇员"),
  ];
  AnimationController animationController;
  FlutterToast flutterToast;

  User user = User(0,'',0,'','','','','','',[],true);
  List<Job> employerJobList = [];
  List<Job> employeeJobList = [];
  // TODO 这里是空白图片
  String _image = 'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png';
  bool _ifImageChanged = false;
  var _newImage;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: tabs.length, vsync: this);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    flutterToast = FlutterToast(context);
    getUser();
    getEmployerJobs();
    getEmployeeJobs();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  getUser() async {
    //获得用户头像
    _image = await StorageUtil.getStringItem("userIcon");
    User u;
    List<String> skills = [];
    String url = "${Url.url_prefix}/getUser?id=" + widget.userId.toString();
    String token = await StorageUtil.getStringItem('token');
    final res = await http.get(url, headers: {"Accept": "application/json","Authorization": "$token"});
    final data = json.decode(res.body);

    for(int i = 0; i < data['skills'].length; ++i){
      skills.add(data['skills'][i]);
    }
    u = new User(data['id'], data['name'], data['age'], data['gender'], data['email'], data['address'], data['phone'], data['time'], data['description'], skills, (data['isShow'] == 0)? false : true);
    setState(() {
      user = u;
    });
  }

  getEmployerJobs() async {
    List<Job> jobs = [];
    var response = [];
    String url = '${Url.url_prefix}/getEmployerJob?userId=' + widget.userId.toString();
    print("我的信息页获得雇主项目  " + widget.userId.toString());
    String token = await StorageUtil.getStringItem('token');
    final res = await http.get(url, headers: {"Accept": "application/json","Authorization": "$token"});
    final data = json.decode(res.body);
    response = data;
    for(int i = 0; i < response.length; ++i){
      if(response[i]['state'] == 2){
        List<String> skills = [];
        for(int j = 0; j < response[i]['skills'].length; ++j){
          skills.add(response[i]['skills'][j].toString());
        }
        jobs.add(Job(response[i]['id'], response[i]['title'], response[i]['description'], skills, response[i]['employeeRate'], response[i]['employerRate'], response[i]['finishTime']));
      }
    }
    setState(() {
      employerJobList = jobs;
    });
  }

  getEmployeeJobs() async {
    List<Job> jobs = [];
    var response = [];
    String url = '${Url.url_prefix}/getEmployeeJob?userId=' + widget.userId.toString();
    String token = await StorageUtil.getStringItem('token');
    final res = await http.get(url, headers: {"Accept": "application/json","Authorization": "$token"});
    final data = json.decode(res.body);
    response = data;
    for(int i = 0; i < response.length; ++i){
      if(response[i]['state'] == 2){
        List<String> skills = [];
        for(int j = 0; j < response[i]['skills'].length; ++j){
          skills.add(response[i]['skills'][j].toString());
        }
        jobs.add(Job(response[i]['id'], response[i]['title'], response[i]['description'], skills, response[i]['employeeRate'], response[i]['employerRate'], response[i]['finishTime']));
      }
    }
    setState(() {
      employeeJobList = jobs;
    });
  }

  Widget jobList(List<Job> jobList, bool isEmployer){
    if(!user.recordCanSee){
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.visibility_off, size: 50,),
            Text("已设置查阅权限", style: TextStyle(fontSize: 18),),
            SizedBox(
              height: 40,
              child: Container(),
            )
          ],
        ),
      );
    }
    else if(jobList.length == 0){
      return Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/empty.png'),
              height: 50,
              width: 50,
            ),
            Text("暂无完成记录", style: TextStyle(fontSize: 18),),
            SizedBox(
              height: 40,
              child: Container(),
            )
          ],
        ),
      );
    }
    else return ListView.builder(
      itemCount: jobList.length,
      padding: const EdgeInsets.only(top: 8),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        final int count =
        jobList.length > 10 ? 10 : jobList.length;
        final Animation<double> animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: animationController,
                curve: Interval(
                    (1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn)));
        animationController.forward();
        return PersonRateJobItem(
          callback: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProjDetails(jobList[index].projectId)));},
          jobData: jobList[index],
          isEmployer: isEmployer,
          animation: animation,
          animationController: animationController,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> skillManageList = user.skills.map((skill) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
      margin: const EdgeInsets.only(right: 6.0, bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey.withOpacity(0.3),
      ),
      child: Text(skill,style: TextStyle(height: 1,fontSize: 14),),
    )).toList();
    skillManageList.add(Container(
      child: Column(
        children: [
          SizedOverflowBox(
            size: Size(32, 32),
            alignment: Alignment.center,
            child: IconButton(
              // action button
              icon: new Icon(Icons.add_circle, color: Colors.black54,),
              padding: const EdgeInsets.all(0),
              onPressed: () {
                _showSimpleDialog();
              },
            ),
          ),
          SizedBox(
            height: 3,
            width: 2,
            child: Container(),
          )
        ],
      ),
    ));

    return new Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            // 头部信息栏
            SliverAppBar(
                leading: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                title: new Text("我的资料",
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400
                    )
                ),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.mail),
                      color: Colors.white,
                      onPressed: () {}
                  )
                ],
                backgroundColor: Colors.blue,
                pinned: true,
                expandedHeight: 250,
                flexibleSpace: new FlexibleSpaceBar(
                    background: new Container(
                        width: MediaQuery.of(context).size.width,
                        padding: new EdgeInsets.all(16.0),
                        height: 200,
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: !_ifImageChanged ? NetworkImage(_image) : FileImage(_newImage),
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(Colors.grey.withOpacity(0.7), BlendMode.darken)
                            )
                        ),
                        child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Container(
                                  width: 95,
                                  height: 95,
                                  child: new CircleAvatar(
                                    backgroundImage: !_ifImageChanged ? NetworkImage(_image) : FileImage(_newImage)
                                  )
                              ),
                              new Expanded(
                                  child: Container(
                                      height: 95,
                                      padding: new EdgeInsets.fromLTRB(16, 0, 0, 0),
                                      child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(user.name, style: new TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                                            new Row(
                                                children: <Widget>[
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                                                    margin: const EdgeInsets.only(right: 15, top: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      color: Colors.white.withOpacity(0.3),
                                                    ),
                                                    child: Text(
                                                      user.age.toString() + '岁',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                                                    margin: const EdgeInsets.only(right: 15, top: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      color: Colors.white.withOpacity(0.3),
                                                    ),
                                                    child: Text(
                                                      user.gender == 'M' ? '男' : '女',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                            )
                                          ]
                                      )
                                  )
                              )
                            ]
                        )
                    )
                )
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((content, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.desktop_windows, color: Colors.black),
                      title: Text("我的项目"),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => OnesJobManagePage(userId: user.userId,)));},
                    ),
                  ],
                );
              }, childCount: 1),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      offset: const Offset(4, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                  child: Container(
                    color: HotelAppTheme.buildLightTheme().backgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 16, left: 16, bottom: 4, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('资料卡',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              RaisedButton(
                                onPressed: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  showDemoDialog(context: context);
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Text('编辑资料', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color: Colors.blue,
                                        width: 1.0,
                                        style: BorderStyle.solid
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Icon(Icons.email, color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(user.email, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Icon(Icons.phone, color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(user.phone, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(user.address, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Icon(Icons.watch_later, color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(user.time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.local_offer, color: Colors.grey),
                              Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 80),
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.end,
                                      children: skillManageList,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.border_color, color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 2),
                                child: Text(user.description,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.start,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      offset: const Offset(4, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: Container(
                    color: HotelAppTheme.buildLightTheme().backgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 16, left: 16, bottom: 4, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text('项目经历',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                              TabBar(
                                isScrollable: true,
                                unselectedLabelColor: Colors.grey,
                                labelColor: Colors.white,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: new BubbleTabIndicator(
                                  indicatorHeight: 25.0,
                                  indicatorColor: Colors.blueAccent,
                                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                ),
                                tabs: tabs,
                                controller: _tabController,
                              ),
                              SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        String url = "${Url.url_prefix}/setShow?userId=" + widget.userId.toString();
                                        String token = await StorageUtil.getStringItem('token');
                                        http.post(url, headers: {"Accept": "application/json","Authorization": "$token"});
                                        setState(() {
                                          user.recordCanSee = !user.recordCanSee;
                                        });
                                      },
                                      icon: user.recordCanSee? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                      color: Colors.blue,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: user.recordCanSee? 600 : 160,
                          child: TabBarView(
                            controller: _tabController,
                            children: tabs.map((Tab tab) {
                              if (tab == tabs[0])
                                return jobList(employerJobList, true);
                              else
                                return jobList(employeeJobList, false);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  //TODO 资料更新未传到后端保存
  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => UserInfoEditModal(
        userInfo: FoundationInfo(
            name: user.name,
            gender: user.gender,
            age: user.age,
            phone: user.phone,
            address: user.address,
            description: user.description,
            image: _image
        ),
        onApplyClick: (FoundationInfo userInfo, bool ifImageChanged, File newImage) {
            setState(() {
              user.name = userInfo.name;
              user.age = userInfo.age;
              user.gender = userInfo.gender;
              user.phone = userInfo.phone;
              user.address = userInfo.address;
              user.description = userInfo.description;
              _image = userInfo.image;
            });
            if(ifImageChanged){
              setState(() {
                _newImage = newImage;
                _ifImageChanged = true;
              });
            }
        },
        onCancelClick: () {},
      ),
    );
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.blueAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, color: Colors.white,),
          SizedBox(
            width: 12.0,
          ),
          Text("更新技能点成功", style: TextStyle(color: Colors.white),),
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
      String url = "${Url.url_prefix}/updateSkills?userId=" + user.userId.toString();
      String token = await StorageUtil.getStringItem('token');
      var res = await http.post(Uri.encodeFull(url),
          headers: {"content-type": "application/json","Authorization": "$token"},
          body:  json.encode(skills));
      var response = json.decode(res.body);
      if (response != null) {
        print("update skills success");
      }
    } catch (e) {
      print(e);
    }
  }

  _showSimpleDialog() {
    onSkillChange(var skills) {
      setState(() {
        user.skills = skills;
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
                skillChoose: user.skills,
                onSkillChanged: onSkillChange,
              ),
            ]
        )
    );
  }
}



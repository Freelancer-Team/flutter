import 'dart:math';
import 'package:flutter/material.dart';
import 'package:freelancer_flutter/component/UserStatisticTable.dart';
import 'dart:ui';
import 'hotel_app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:freelancer_flutter/component/ProjectStatisticTable.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'config.dart';
import 'package:toggle_switch/toggle_switch.dart';


class StatisticView extends StatefulWidget {
  StatisticView({Key key}) : super(key: key);

  @override
  _StatisticViewState createState() => new _StatisticViewState();
}

class _StatisticViewState extends State<StatisticView> with SingleTickerProviderStateMixin {

  AnimationController animationController;

  final ScrollController _scrollController = ScrollController();
  final width = window.physicalSize.width;

  bool isProjectView = true;

  List<StatisticJob> originJobList = [];
  List<StatisticJob> jobList = [];
  String searchCondition;
  String chooseJobState = "待审阅";

  List<StatisticUser> originUserList = [];
  List<StatisticUser> userList = [];
  String chooseUserRole = "所有用户";

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    getJobs();
    getUsers();
  }

  //假数据随机数
  int getState() {
    return new Random().nextInt(6) - 3;
  }
  String getDeadline() {
    return '2020-0' + (new Random().nextInt(9) + 1).toString() + '-' + (new Random().nextInt(20) + 10).toString();
  }
  int getCandidateNumber() {
    return new Random().nextInt(50);
  }
  int getAccessTimes() {
    return new Random().nextInt(1000);
  }

  getJobs() async {
    List<StatisticJob> jobs = [];
    List<StatisticJob> chooseJobs = [];
    var response = [];
    String url = "${Url.url_prefix}/getJobs";
    final res = await http.get(url);
    final data = json.decode(res.body);
    response = data;
    for(int i = 0; i < response.length; ++i){
      List<String> skills = [];
      for(int j = 0; j < response[i]['skills'].length; ++j){
        skills.add(response[i]['skills'][j].toString());
      }
      jobs.add(StatisticJob(response[i]['id'], response[i]['title'], getState(), getDeadline(), getAccessTimes(), getCandidateNumber()));
    }
    setState(() {
      originJobList = jobs;
    });
    for(int i = 0; i < originJobList.length; ++i){
      if(originJobList[i].state == -3) chooseJobs.add(originJobList[i]);
    }
    setState(() {
      jobList = chooseJobs;
    });
  }

  /*得到随机数*/
  int getRandom() {
    return new Random().nextInt(4) - 2;
  }

  getUsers() async {
    List<StatisticUser> users = [];
    var response = [];
    String url = "${Url.url_prefix}/getUsers";
    String token = await StorageUtil.getStringItem('token');
    final res = await http.get(url, headers: {"Accept": "application/json","Authorization": "$token"});
    final data = json.decode(res.body);
    response = data;
    for(int i = 0; i < response.length; ++i){
      List<String> skills = [];
      for(int j = 0; j < response[i]['skills'].length; ++j){
        skills.add(response[i]['skills'][j].toString());
      }
      users.add(StatisticUser(response[i]['id'], response[i]['name'], getRandom(), getCandidateNumber(), getCandidateNumber()));
    }
    setState(() {
      originUserList = users;
      userList = users;
    });
  }

  executeJobSearch() {
    List<StatisticJob> jobs = [];
    for(int i = 0; i < originJobList.length; ++i){
      if(originJobList[i].projectName.contains(searchCondition)) jobs.add(originJobList[i]);
    }
    setState(() {
      jobList = jobs;
    });
  }

  executeUserSearch() {
    List<StatisticUser> users = [];
    for(int i = 0; i < originJobList.length; ++i){
      if(originUserList[i].name.contains(searchCondition)) users.add(originUserList[i]);
    }
    setState(() {
      userList = users;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  getSearchBarUI(),
                                ],
                              );
                            }, childCount: 1),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: ContestTabHeader(
                          getFilterBarUI(),
                        ),
                      ),
                    ];
                  },
                  body: Padding(
                    padding: EdgeInsets.all(16),
                    child: isProjectView ? ProjectStatisticTable(jobList) : UserStatisticTable(userList),
                  )
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {
                      searchCondition = txt;
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HexColor('#54D3C2'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: HexColor('#54D3C2'),
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  isProjectView ? executeJobSearch() : executeUserSearch();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search,
                      size: 20,
                      color: const Color(0xFFFFFFFF)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: HotelAppTheme.buildLightTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 8.0),
            ],
          ),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ToggleSwitch(
                            minWidth: 120.0,
                            cornerRadius: 20,
                            activeBgColor: HexColor('#54D3C2'),
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey.withOpacity(0.6),
                            inactiveFgColor: Colors.white,
                            labels: ['项目数据', '用户数据'],
                            icons: [Icons.desktop_windows, Icons.group],
                            onToggle: (index) {
                              if(index == 1) setState(() {
                                isProjectView = false;
                              });
                              else setState(() {
                                isProjectView = true;
                              });
                            }),
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: isProjectView ? getJobDropDownMenu() : getUserDropDownMenu(),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort,
                                color: HotelAppTheme.buildLightTheme()
                                    .primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getJobDropDownMenu() {
    return DropdownButton<String>(
      value: chooseJobState,
      icon: Icon(Icons.arrow_drop_down, color: HexColor('#54D3C2'),),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(fontWeight: FontWeight.w100, color: Colors.black),
      underline: Container(
        height: 1,
        color: Colors.grey.withOpacity(0.6),
      ),
      onChanged: (String newValue) {
        setState(() {
          chooseJobState = newValue;
        });
        executeChooseJobState();
      },
      items: <String>['所有项目', '待审阅', '竞标中', '已过期', '禁用的', '关闭的', '进行中', '已完成']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget getUserDropDownMenu() {
    return DropdownButton<String>(
      value: chooseUserRole,
      icon: Icon(Icons.arrow_drop_down, color: HexColor('#54D3C2'),),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(fontWeight: FontWeight.w100, color: Colors.black),
      underline: Container(
        height: 1,
        color: Colors.grey.withOpacity(0.6),
      ),
      onChanged: (String newValue) {
        setState(() {
          chooseUserRole = newValue;
        });
      },
      items: <String>['所有用户', '待核验', '已核验', '已封禁', '管理员']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  executeChooseJobState() {
    List<StatisticJob> jobs = [];
    int state;
    bool judgeTime = false;
    bool isBid = true;
    switch(chooseJobState){
      case '所有项目': {
        setState(() {
          jobList = originJobList;
        });
        return;
      }
      break;
      case '待审阅': {
        state = -3;
      }
      break;
      case '关闭的': {
        state = -2;
      }
      break;
      case '禁用的': {
        state = -1;
      }
      break;
      case '竞标中': {
        state = 0;
        judgeTime = true;
      }
      break;
      case '已过期': {
        state = 0;
        judgeTime = true;
        isBid = false;
      }
      break;
      case '进行中': {
        state = 1;
      }
      break;
      case '已完成': {
        state = 2;
      }
      break;
    }
    for(int i = 0; i < originJobList.length; ++i){
      if(originJobList[i].state == state) jobs.add(originJobList[i]);
    }
    if(judgeTime){
      List<StatisticJob> timeSatisfyJobs = [];
      var now = DateTime.now();
      if(isBid){
        for(int i = 0; i < jobs.length; ++i){
          var then = DateTime.parse(jobs[i].deadline);
          if(then.isAfter(now)) timeSatisfyJobs.add(jobs[i]);
        }
      }
      else{
        for(int i = 0; i < jobs.length; ++i){
          var then = DateTime.parse(jobs[i].deadline);
          if(then.isBefore(now)) timeSatisfyJobs.add(jobs[i]);
        }
      }
      setState(() {
        jobList = timeSatisfyJobs;
      });
    }
    else setState(() {
      jobList = jobs;
    });
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
      this.searchUI,
      );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freelancer_flutter/component/AuctionTables.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:freelancer_flutter/component/ProjectTables.dart';
import 'package:freelancer_flutter/component/config.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


//TODO 后端需增加项目数据域————确定接单人后的'具体佣金'，用于进行中和已完成的项目数据表，否则需前端三次请求
//TODO 表的搜索未实现
class OnesJobManagePage extends StatefulWidget {
  OnesJobManagePage({this.userId});

  final int userId;

  @override
  _OnesJobManagePageState createState() => _OnesJobManagePageState();
}

class _OnesJobManagePageState extends State<OnesJobManagePage> {

  String chooseView = 'employer';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '我的项目',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          body: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.only(top: 15, bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
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
                      (chooseView == 'employer') ? EmployerView(userId: widget.userId,) : EmployeeView(userId: widget.userId,)
                    ]
                ),
              )
          )
        ),

    );
  }
}

class EmployerView extends StatefulWidget {

  EmployerView({this.userId});

  final int userId;

  @override
  _EmployerViewState createState() => _EmployerViewState();
}

class _EmployerViewState extends State<EmployerView> with SingleTickerProviderStateMixin {

  TabController mController;
  List<String> tabTitles;

  List<StatisticProject> employerProceeding = [];
  List<StatisticProject> employerComplete = [];
  List<Auction> auctionList = [];

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
    getEmployerJobs();
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }

  getEmployerJobs() async {
    List<StatisticProject> completeJobs = [];
    List<StatisticProject> proceedingJobs = [];
    List<Auction> auctions = [];
    var response = [];
    int userID;
    if(widget.userId != null) userID = widget.userId;
    else userID = await StorageUtil.getIntItem("uid");
    String url = '${Url.url_prefix}/getEmployerJob?userId=' + userID.toString();
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
        completeJobs.add(
            StatisticProject(
                projectId: response[i]['id'],
                projectName: response[i]['title'],
                employeeId: response[i]['employeeId'],
                employeeName: response[i]['employeeName'],
                employeeRate: response[i]['employeeRate'],
                employerId: response[i]['employerId'],
                employerName: response[i]['employerName'],
                employerRate: response[i]['employerRate'],
                startTime: response[i]['startTime'],
                finishTime: response[i]['finishTime'],
                price: response[i]['avgPrice']
            )
        );
      }
      else if(response[i]['state'] == 1){
        List<String> skills = [];
        for(int j = 0; j < response[i]['skills'].length; ++j){
          skills.add(response[i]['skills'][j].toString());
        }
        proceedingJobs.add(
            StatisticProject(
                projectId: response[i]['id'],
                projectName: response[i]['title'],
                employeeId: response[i]['employeeId'],
                employeeName: response[i]['employeeName'],
                employeeRate: response[i]['employeeRate'],
                employerId: response[i]['employerId'],
                employerName: response[i]['employerName'],
                employerRate: response[i]['employerRate'],
                startTime: response[i]['startTime'],
                finishTime: response[i]['finishTime'],
                price: response[i]['avgPrice']
            )
        );
      }
      else{
        auctions.add(
          Auction(
            projectId: response[i]['id'],
            projectName: response[i]['title'],
            projectState: response[i]['state'],
            lowestPrice: 9,
            avgPrice: 14,
            deadline: response[i]['deadline'],
          )
        );
      }
    }
    setState(() {
      employerProceeding = proceedingJobs;
      employerComplete = completeJobs;
      auctionList = auctions;
    });
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
                      columnNames: ["项目名称","雇员","佣金","接单日期","违约金"],
                      tableKind: "employerProceeding",
                      jobList: employerProceeding,
                    );
                  else if(item == "已完成")
                    return DataTableDemo(
                      columnNames: ["项目名称","雇员","佣金","完成日期","雇员评分"],
                      tableKind: "employerComplete",
                      jobList: employerComplete,
                    );
                  else return EmployerAuctionTable(
                      auctionList: auctionList,
                    );
                }).toList(),
              ),
            ),
          ],
        ));
  }
}

class EmployeeView extends StatefulWidget {

  EmployeeView({this.userId});

  final int userId;

  @override
  _EmployeeViewState createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> with SingleTickerProviderStateMixin {

  TabController mController;
  List<String> tabTitles;

  List<StatisticProject> employeeProceeding = [];
  List<StatisticProject> employeeComplete = [];
  List<Auction> auctionList = [];

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
    getEmployeeJobs();
    getAuction();
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }

  getEmployeeJobs() async {
    List<StatisticProject> completeJobs = [];
    List<StatisticProject> proceedingJobs = [];
    var response = [];
    int userID;
    if(widget.userId != null) userID = widget.userId;
    else userID = await StorageUtil.getIntItem("uid");
    String url = '${Url.url_prefix}/getEmployeeJob?userId=' + userID.toString();
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
        completeJobs.add(
            StatisticProject(
                projectId: response[i]['id'],
                projectName: response[i]['title'],
                employeeId: response[i]['employeeId'],
                employeeName: response[i]['employeeName'],
                employeeRate: response[i]['employeeRate'],
                employerId: response[i]['employerId'],
                employerName: response[i]['employerName'],
                employerRate: response[i]['employerRate'],
                startTime: response[i]['startTime'],
                finishTime: response[i]['finishTime'],
                price: response[i]['avgPrice']
            )
        );
      }
      if(response[i]['state'] == 1){
        List<String> skills = [];
        for(int j = 0; j < response[i]['skills'].length; ++j){
          skills.add(response[i]['skills'][j].toString());
        }
        proceedingJobs.add(
            StatisticProject(
                projectId: response[i]['id'],
                projectName: response[i]['title'],
                employeeId: response[i]['employeeId'],
                employeeName: response[i]['employeeName'],
                employeeRate: response[i]['employeeRate'],
                employerId: response[i]['employerId'],
                employerName: response[i]['employerName'],
                employerRate: response[i]['employerRate'],
                startTime: response[i]['startTime'],
                finishTime: response[i]['finishTime'],
                price: response[i]['avgPrice']
            )
        );
      }
    }
    setState(() {
      employeeProceeding = proceedingJobs;
      employeeComplete = completeJobs;
    });
  }

  getAuction() async {
    List<Auction> auctions = [];
    var response = [];
    int userID;
    if(widget.userId != null) userID = widget.userId;
    else userID = await StorageUtil.getIntItem("uid");
    String url = '${Url.url_prefix}/getEmployeeJob?userId=' + userID.toString();
    String token = await StorageUtil.getStringItem('token');
    final res = await http.get(url, headers: {"Accept": "application/json","Authorization": "$token"});
    final data = json.decode(res.body);
    response = data;
    for(int i = 0; i < response.length; ++i){
      if(response[i]['state'] == 2){
        auctions.add(
            Auction(
              projectId: response[i]['id'],
              projectName: response[i]['title'],
              projectState: Random().nextInt(3)-3,
              auctionState: 1,
              myPrice: 10,
              avgPrice: 14,
              deadline: response[i]['deadline']
            )
        );
      }
    }
    setState(() {
      auctionList = auctions;
    });
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
                      columnNames: ["项目名称","雇主","佣金","接单日期","违约金"],
                      tableKind: "employeeProceeding",
                      jobList: employeeProceeding,
                    );
                  else if(item == "已完成")
                    return DataTableDemo(
                      columnNames: ["项目名称","雇主","佣金","完成日期","雇主评分"],
                      tableKind: "employeeComplete",
                      jobList: employeeComplete,
                    );
                  else return EmployeeAuctionTable(
                      auctionList: auctionList,
                    );
                }).toList(),
              ),
            ),
          ],
        ));
  }
}

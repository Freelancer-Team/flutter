import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freelancer_flutter/component/MyDrawer.dart';
import 'package:freelancer_flutter/pages/apply.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class ProjDetails extends StatefulWidget {
  ProjDetails(this.id);
  var id;
  State<StatefulWidget> createState() {
    final width = window.physicalSize.width;
    if (width > 1080) {
      return LargeScreen(id);
    } else {
      return SmallScreen(id);
    }
  }
}


class LargeScreen extends State<ProjDetails>
    with SingleTickerProviderStateMixin {
  LargeScreen(this.ID);
  var ID ;
  bool isEdit = false;
  bool isManager = false;
  bool isLog = false;
  TabController mController;
  List<String> tabTitles;
  final List entries = ['名称', '描述', '薪资', '地址', '人数', '剩余时间', '联系方式'];
  List ProjInfo = [
    'ID',
    '床上睡觉',
    '这是一个钱多事少离家近的好项目',
    '有多少给多少',
    '床',
    '1',
    '1314',
    '54749110'
  ];
  final List entries2 = ['姓名', '联系方式', '邮箱'];
  List UserInfo = ['id','lyb', '54749110', '1@qq.com', '东川路800'];
  List AuctionInfo = [
    ['name1', 'price1', 'message1'],
    ['name2', 'price2', 'message2'],
    ['name3', 'price3', 'message3'],
    ['name4', 'price4', 'message4']
  ];
  List<String> skills = new List();
  List EmployerInfo =['id','name','address','phone'];

  var array;
  var array2;
  var array3;
  Future<http.Response> fetchPost() async {
    var url = "http://localhost:8080/getJob?id=" + ID;
    var response = await http
        .post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final data = json.decode(response.body);
    setState(() {
      array = data;
      ProjInfo[0] = array['id'];
      ProjInfo[1] = array['title'];
      ProjInfo[2] = array['description'];
      ProjInfo[3] = array['price'];
      ProjInfo[6] = array['remaining_time'];
      EmployerInfo[0] = array['employerId'].toString();
      EmployerInfo[1] = array['employerName'];
      UserInfo[0] = array['employeeId'].toString();
      for (int i = 0; i < array['skills'].length; i++) {
        skills.add(array['skills'][i].toString());
      }
    });
    url = "http://localhost:8080/getUser?id=" + EmployerInfo[0];
    response = await http
        .post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final data2 = json.decode(response.body);
    setState(() {
      array2 = data2;
      EmployerInfo[2] = array2['address'];
      EmployerInfo[3] = array2['phone'];
      ProjInfo[4] = array2['address'];
      ProjInfo[7] = array2['phone'];
    });
    url = "http://localhost:8080/getUser?id=" + UserInfo[0];
    response = await http
        .post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final data3 = json.decode(response.body);
    setState(() {
      array3 = data3;
      UserInfo[1] = array3['name'];
      UserInfo[2] = array3['phone'];
      UserInfo[3] = array3['email'];
    });
  }

  savePost() async {
    var url = "http://localhost:8080/saveJob";
    var response = await http.post(url,
        headers: {"content-type": "application/json"},
        body: json.encode(array));
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
    tabTitles = [
      "详情",
      "竞价",
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Freelancer',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          bottom: PreferredSize(
            child: Container(
              child: Text(
                '项目详情',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          brightness: Brightness.light,
        ),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Container(
                  width: 0.75 * width,
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Card(
                    child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                          toolbarHeight: 50,
                          title: Text('${ProjInfo[1]}'),
                          centerTitle: false,
                          actions: <Widget>[
                            Offstage(
                              offstage: isManager,
                              child: FlatButton(
                                child: new Text(
                                  '我想试试',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  !isLog?Navigator.pushNamed(context, "/login"): Navigator.push(context, MaterialPageRoute(builder: (context) =>ApplyPage(ProjInfo[0],ProjInfo[1],ProjInfo[3],skills)));
                                },
                              ),
                            ),
                            Offstage(
                                offstage: !isManager,
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      this.isEdit = true;
                                    });
                                  },
                                )),
                            Offstage(
                                offstage: !isEdit,
                                child: IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () {
                                    setState(() {
                                      this.isEdit = false;
                                    });
                                    array['id'] = ProjInfo[0];
                                    array['title'] = ProjInfo[1];
                                    array['description'] = ProjInfo[2];
                                    array['price'] = ProjInfo[3];
                                    array['remaining_time'] = ProjInfo[6];
                                    print(array);
                                    savePost();
                                  },
                                ))
                          ],
                        ),
                        body: Column(
                          children: <Widget>[
                            Container(
                              color: new Color(0xfff4f5f6),
                              height: 38.0,
                              child: TabBar(
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
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: mController,
                                children: tabTitles.map((item) {
                                  if (item == "详情")
                                    return ListView.separated(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: entries.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 4, 8, 4),
                                            alignment: Alignment.centerLeft,
                                            constraints:
                                                BoxConstraints(minHeight: 68),
//                                            height: 68,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  child: Text(
                                                    '${entries[index]}：',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      Offstage(
                                                        offstage: !isEdit,
                                                        child: TextFormField(
                                                          autofocus: true,
                                                          controller:
                                                          TextEditingController()
                                                            ..text =
                                                                '${ProjInfo[index + 1]}',
                                                          decoration: InputDecoration(
                                                            disabledBorder:
                                                            InputBorder.none,
                                                            focusedBorder:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    5.0),
                                                                borderSide:
                                                                BorderSide(
                                                                  width: 0.5,
                                                                )),
                                                          ),
                                                          enabled: isEdit,
                                                          textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                          onFieldSubmitted: (value) {
                                                            ProjInfo[index + 1] =
                                                                value;
                                                          },
                                                        ),
                                                      ),
                                                      Offstage(
                                                        offstage: isEdit,
                                                        child: Text('${ProjInfo[index + 1]}',
                                                            style:TextStyle(fontSize: 16),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                )
                                              ],
                                            ));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              Container(
                                                  height: 1.0,
                                                  color: Colors.grey),
                                    );
                                  else
                                    return ListView.separated(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: AuctionInfo.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.fromLTRB(
                                                100, 8, 0, 8),
                                            height: 100,
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 50, 0),
                                                  child: Image(
                                                    image: AssetImage(
                                                        "assets/notFind.jpeg"),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                        'Name：${AuctionInfo[index][0]}'),
                                                    Text(
                                                        'Price：${AuctionInfo[index][1]}'),
                                                    Text(
                                                        'Message：${AuctionInfo[index][2]}'),
                                                  ],
                                                )
                                              ],
                                            ));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              Container(
                                                  height: 1.0,
                                                  color: Colors.grey),
                                    );
                                }).toList(),
                              ),
                            ),
                          ],
                        )),
                  )),
              Container(
                  width: 0.25 * width,
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Stack(
                    children: [
                      Offstage(
                        offstage: isManager,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 24.0, 8.0, 8.0),
                                  itemCount: 3,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == 0)
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Text(
                                                '发布公司/个人',
                                                style: TextStyle(fontSize: 22),
                                              ),
//                                Image(),
                                              Text('${EmployerInfo[1]}'),
                                              Text('${EmployerInfo[2]}'),
                                              Text('${EmployerInfo[3]}'),
                                            ],
                                          ));
                                    else if (index == 1)
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 80,
                                          child: Column(
                                            children: [
                                              Text('认证信息'),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.accessibility),
                                                  Icon(Icons.home),
                                                  Icon(Icons.cached),
                                                  Icon(Icons.dashboard),
                                                  Icon(Icons.face),
                                                ],
                                              )
                                            ],
                                          ));
                                    else
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 80,
                                          child: Column(
                                            children: [Text('评分')],
                                          ));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Container(
                                              height: 1.0, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !isManager,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 24.0, 8.0, 8.0),
                                  itemCount: 2,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == 0)
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Text(
                                                '接单人',
                                                style: TextStyle(fontSize: 22),
                                              ),
                                              Container(
                                                height: 80,
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/notFind.jpeg"),
                                                ),
                                              ),
                                              Expanded(
                                                  child: ListView.builder(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      itemCount:
                                                          entries2.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          height: 20,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              '${entries2[index]}: ${UserInfo[index]}'),
                                                        );
                                                      })),
                                            ],
                                          ));
                                    else
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 80,
                                          child: Column(
                                            children: [Text('评分')],
                                          ));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Container(
                                              height: 1.0, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}

class SmallScreen extends State<ProjDetails>
    with SingleTickerProviderStateMixin {
  SmallScreen(this.ID);
  var ID;
  bool isEdit = false;
  bool isManager = false;
  bool isLog = false;
  TabController mController;
  List<String> tabTitles;
  final List entries = ['名称', '描述', '薪资', '地址', '人数', '剩余时间', '联系方式'];
  List ProjInfo = [
    'ID',
    '床上睡觉',
    '这是一个钱多事少离家近的好项目',
    '有多少给多少',
    '床',
    '1',
    '1314',
    '54749110'
  ];
  final List entries2 = ['姓名', '联系方式', '邮箱'];
  List UserInfo = ['id','lyb', '54749110', '1@qq.com', '东川路800'];
  List AuctionInfo = [
    ['name1', 'price1', 'message1'],
    ['name2', 'price2', 'message2'],
    ['name3', 'price3', 'message3'],
    ['name4', 'price4', 'message4']
  ];
  List<String> skills = new List();
  List EmployerInfo =['id','name','address','phone'];

  var array;
  var array2;
  var array3;
  Future<http.Response> fetchPost() async {
    int uid = await StorageUtil.getIntItem("uid");
    if (uid != null)
      setState(() {
        isLog = true;
      });
    var url = "http://localhost:8080/getJob?id=" + ID;
    var response = await http
        .post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final data = json.decode(response.body);
    setState(() {
      array = data;
      ProjInfo[0] = array['id'];
      ProjInfo[1] = array['title'];
      ProjInfo[2] = array['description'];
      ProjInfo[3] = array['price'];
      ProjInfo[6] = array['remaining_time'];
      EmployerInfo[0] = array['employerId'].toString();
      EmployerInfo[1] = array['employerName'];
      UserInfo[0] = array['employeeId'].toString();
      for (int i = 0; i < array['skills'].length; i++) {
        skills.add(array['skills'][i].toString());
      }
    });
    url = "http://localhost:8080/getUser?id=" + EmployerInfo[0];
    response = await http
        .post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final data2 = json.decode(response.body);
    setState(() {
      array2 = data2;
      EmployerInfo[2] = array2['address'];
      EmployerInfo[3] = array2['phone'];
      ProjInfo[4] = array2['address'];
      ProjInfo[7] = array2['phone'];
    });
    url = "http://localhost:8080/getUser?id=" + UserInfo[0];
    response = await http
        .post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final data3 = json.decode(response.body);
    setState(() {
      array3 = data3;
      UserInfo[1] = array3['name'];
      UserInfo[2] = array3['phone'];
      UserInfo[3] = array3['email'];
    });
  }

  savePost() async {
    var url = "http://localhost:8080/saveJob";
    var response = await http.post(url, headers: {
      "content-type": "application/json"
    }, body: json.encode(array));
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
    tabTitles = [
      "详情",
      "竞价",
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Freelancer',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          bottom: PreferredSize(
            child: Container(
              child: Text(
                '项目详情',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          brightness: Brightness.light,
        ),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                  height: 700,
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Card(
                    child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                          toolbarHeight: 50,
                          title: Text('${ProjInfo[1]}'),
                          centerTitle: false,
                          actions: <Widget>[
                            Offstage(
                              offstage: isManager,
                              child: FlatButton(
                                child: new Text(
                                  '我想试试',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  !isLog
                                      ? Navigator.pushNamed(context, "/login")
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ApplyPage(
                                                  ProjInfo[0],
                                                  ProjInfo[1],
                                                  ProjInfo[3],
                                                  skills)));
                                },
                              ),
                            ),
                            Offstage(
                                offstage: !isManager,
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      this.isEdit = true;
                                    });
                                  },
                                )),
                            Offstage(
                                offstage: !isEdit,
                                child: IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () {
                                    setState(() {
                                      this.isEdit = false;
                                    });
                                    array['id'] = ProjInfo[0];
                                    array['title'] = ProjInfo[1];
                                    array['description'] = ProjInfo[2];
                                    array['price'] = ProjInfo[3];
                                    array['remaining_time'] = ProjInfo[6];
                                    print(array);
                                    savePost();
                                  },
                                ))
                          ],
                        ),
                        body: Column(
                          children: <Widget>[
                            Container(
                              color: new Color(0xfff4f5f6),
                              height: 38.0,
                              child: TabBar(
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
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: mController,
                                children: tabTitles.map((item) {
                                  if (item == "详情")
                                    return ListView.separated(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: entries.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 4, 8, 4),
                                            alignment: Alignment.centerLeft,
                                            constraints:
                                            BoxConstraints(minHeight: 68),
//                                            height: 68,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  child: Text(
                                                    '${entries[index]}：',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Stack(
                                                  children: [
                                                    Offstage(
                                                      offstage: !isEdit,
                                                      child: TextFormField(
                                                        autofocus: true,
                                                        controller:
                                                            TextEditingController()
                                                              ..text =
                                                                  '${ProjInfo[index + 1]}',
                                                        decoration:
                                                            InputDecoration(
                                                          disabledBorder:
                                                              InputBorder.none,
                                                              focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      5.0),
                                                                  borderSide:
                                                                  BorderSide(
                                                                    width: 0.5,
                                                                  )),
                                                            ),
                                                            enabled: isEdit,
                                                            textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        onFieldSubmitted:
                                                            (value) {
                                                          ProjInfo[index + 1] =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                    Offstage(
                                                      offstage: isEdit,
                                                      child: Text(
                                                        '${ProjInfo[index + 1]}',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                              ],
                                            ));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              Container(
                                                  height: 1.0,
                                                  color: Colors.grey),
                                    );
                                  else
                                    return ListView.separated(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: AuctionInfo.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.fromLTRB(
                                                100, 8, 0, 8),
                                            height: 100,
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 50, 0),
                                                  child: Image(
                                                    image: AssetImage(
                                                        "assets/notFind.jpeg"),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                        'Name：${AuctionInfo[index][0]}'),
                                                    Text(
                                                        'Price：${AuctionInfo[index][1]}'),
                                                    Text(
                                                        'Message：${AuctionInfo[index][2]}'),
                                                  ],
                                                )
                                              ],
                                            ));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              Container(
                                                  height: 1.0,
                                                  color: Colors.grey),
                                    );
                                }).toList(),
                              ),
                            ),
                          ],
                        )),
                  )),
              Container(
                  height: 500,
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Stack(
                    children: [
                      Offstage(
                        offstage: isManager,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 24.0, 8.0, 8.0),
                                  itemCount: 3,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == 0)
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Text(
                                                '发布公司/个人',
                                                style: TextStyle(fontSize: 22),
                                              ),
//                                Image(),
                                              Text('${EmployerInfo[1]}'),
                                              Text('${EmployerInfo[2]}'),
                                              Text('${EmployerInfo[3]}'),
                                            ],
                                          ));
                                    else if (index == 1)
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 80,
                                          child: Column(
                                            children: [
                                              Text('认证信息'),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.accessibility),
                                                  Icon(Icons.home),
                                                  Icon(Icons.cached),
                                                  Icon(Icons.dashboard),
                                                  Icon(Icons.face),
                                                ],
                                              )
                                            ],
                                          ));
                                    else
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 80,
                                          child: Column(
                                            children: [Text('评分')],
                                          ));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Container(
                                              height: 1.0, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !isManager,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 24.0, 8.0, 8.0),
                                  itemCount: 2,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == 0)
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Text(
                                                '接单人',
                                                style: TextStyle(fontSize: 22),
                                              ),
                                              Container(
                                                height: 80,
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/notFind.jpeg"),
                                                ),
                                              ),
                                              Expanded(
                                                  child: ListView.builder(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      itemCount:
                                                          entries2.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          height: 20,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              '${entries2[index]}: ${UserInfo[index]}'),
                                                        );
                                                      })),
                                            ],
                                          ));
                                    else
                                      return Container(
                                          alignment: Alignment.center,
                                          height: 80,
                                          child: Column(
                                            children: [Text('评分')],
                                          ));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Container(
                                              height: 1.0, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
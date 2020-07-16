import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freelancer_flutter/component/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class ProjDetails extends StatefulWidget {
  State<StatefulWidget> createState() {
    final width = window.physicalSize.width;
    if (width > 1080) {
      return LargeScreen();
    } else {
      return SmallScreen();
    }
  }
}


class LargeScreen extends State<ProjDetails>
    with SingleTickerProviderStateMixin {
  bool isEdit = false;
  bool isManager = true;
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
  List UserInfo = ['lyb', '54749110', '1@qq.com', '东川路800'];
  List AuctionInfo = [
    ['name1', 'price1', 'message1'],
    ['name2', 'price2', 'message2'],
    ['name3', 'price3', 'message3'],
    ['name4', 'price4', 'message4']
  ];

  var array = [];
  Future<http.Response> fetchPost() async {
    final response = await http.get('http://localhost:8080/getJobs');
    final data = json.decode(response.body);
    setState(() {
      array = data;
      ProjInfo[0] = array[0]['id'];
      ProjInfo[1] = array[0]['title'];
      ProjInfo[2] = array[0]['description'];
      ProjInfo[3] = array[0]['price'];
      ProjInfo[6] = array[0]['remaining_time'];
    });
    print(ProjInfo);
    return response;
  }

  updatePost() async {
    var url = "http://localhost:8080/updateJobs";
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "id": ProjInfo[0],
      "price": ProjInfo[3],
      "description": ProjInfo[2],
      "remaining_time": ProjInfo[6],
      "title": ProjInfo[1],
      "address": ProjInfo[4],
      "people": ProjInfo[5],
      "phone": ProjInfo[7],
    });
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
                                  Navigator.pushNamed(context, '/apply');
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
                                                16, 8, 8, 8),
                                            alignment: Alignment.centerLeft,
                                            height: 60,
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
                                                  child: TextFormField(
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
                                                                  BorderSide()),
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
                                              Text('name')
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
  bool isEdit = false;
  bool isManager = true;
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
  List UserInfo = ['lyb', '54749110', '1@qq.com', '东川路800'];
  List AuctionInfo = [
    ['name1', 'price1', 'message1'],
    ['name2', 'price2', 'message2'],
    ['name3', 'price3', 'message3'],
    ['name4', 'price4', 'message4']
  ];

  var array = [];
  Future<http.Response> fetchPost() async {
    final response = await http.get('http://localhost:8080/getJobs');
    final data = json.decode(response.body);
    setState(() {
      array = data;
      ProjInfo[0] = array[0]['id'];
      ProjInfo[1] = array[0]['title'];
      ProjInfo[2] = array[0]['description'];
      ProjInfo[3] = array[0]['price'];
      ProjInfo[6] = array[0]['remaining_time'];
    });
    print(ProjInfo);
    return response;
  }

  updatePost() async {
    var url = "http://localhost:8080/updateJobs";
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "id": ProjInfo[0],
      "price": ProjInfo[3],
      "description": ProjInfo[2],
      "remaining_time": ProjInfo[6],
      "title": ProjInfo[1],
      "address": ProjInfo[4],
      "people": ProjInfo[5],
      "phone": ProjInfo[7],
    });
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
                  height: 600,
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
                                  Navigator.pushNamed(context, '/apply');
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
                                                16, 8, 8, 8),
                                            alignment: Alignment.centerLeft,
                                            height: 60,
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
                                                  child: TextFormField(
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
                                                                  BorderSide()),
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
                                                20, 8, 0, 8),
                                            height: 100,
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 20, 0),
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
                  height: 400,
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
                                              Text('name')
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

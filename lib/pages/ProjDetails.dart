import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freelancer_flutter/component/MyDrawer.dart';
import 'package:freelancer_flutter/pages/apply.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:freelancer_flutter/component/RatingBar.dart';
import 'package:freelancer_flutter/component/config.dart';

class ProjDetails extends StatefulWidget {
  ProjDetails(this.ID);
  var ID;

  State<StatefulWidget> createState() {
    final width = window.physicalSize.width;
    var isLarge = width > 1080;
    return Screen(ID, isLarge);
  }
}

class Screen extends State<ProjDetails> with SingleTickerProviderStateMixin {
  ValueNotifier<double> W = ValueNotifier<double>(window.physicalSize.width);
  Screen(this.ID, this.isLarge);
  var ID;
  var isLarge;
  var _uid;
  bool isEdit = false;
  bool isManager = true;
  bool isLog = false;
  TabController mController;
  List<String> tabTitles = ["详情", "竞价", "进度"];
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
  List UserInfo = ['id', 'lyb', '54749110', '1@qq.com', '东川路800'];
  List AuctionInfo = [
    ['name1', 'price1', 'message1'],
    ['name2', 'price2', 'message2'],
    ['name3', 'price3', 'message3'],
    ['name4', 'price4', 'message4']
  ];
  List<String> skills = new List();
  List EmployerInfo = ['id', 'name', 'address', 'phone'];

  var array;
  var array2;
  var array3;
  Future<http.Response> fetchPost() async {
    int uid = await StorageUtil.getIntItem("uid");
    if (uid != null)
      setState(() {
        isLog = true;
        _uid = uid;
      });
    var url = "${Url.url_prefix}/getJob?id=" +ID;
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
      if (_uid == array['employerId']) {
        isManager = true;
      }
    });
    url = "${Url.url_prefix}/getUser?id=" + EmployerInfo[0];
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
    url = "${Url.url_prefix}/getUser?id=" + UserInfo[0];
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
    var url = "${Url.url_prefix}/saveJob";
    var response = await http.post(url,
        headers: {"content-type": "application/json"},
        body: json.encode(array));
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
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

  String ratingValue;
  String value() {
    if (ratingValue == null) {
      return '评分：9 分';
    } else {
      return '评分：$ratingValue  分';
    }
  }

  void _showRatingDialog() {
    // We use the built in showDialog function to show our Rating Dialog
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return StatefulBuilder(
              builder:
              (BuildContext context, void Function(void Function()) setState){
                return SimpleDialog(title: Text('请评分'),
                    // 这里传入一个选择器列表即可
                    children: [
                      Center(
                        child: RatingBar(
                          value: 9,
                          size: 30,
                          padding: 5,
                          nomalImage: 'assets/star_nomal.png',
                          selectImage: 'assets/star.png',
                          selectAble: true,
                          onRatingUpdate: (value) {
                            setState(() {
                              ratingValue = value;
                            });
                          },
                          maxRating: 10,
                          count: 5,
                        ),
                      ),
                      Text(value())
                    ]);
              });
        });
  }


  Widget _detail() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
            alignment: Alignment.centerLeft,
            constraints: BoxConstraints(minHeight: 68),
            child: Row(
              children: [
                Container(
                  width: 100,
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    '${entries[index]}：',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Offstage(
                      offstage: !isEdit,
                      child: TextFormField(
                        autofocus: true,
                        controller: TextEditingController()
                          ..text = '${ProjInfo[index + 1]}',
                        decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                width: 0.5,
                              )),
                        ),
                        enabled: isEdit,
                        textAlignVertical: TextAlignVertical.center,
                        onFieldSubmitted: (value) {
                          ProjInfo[index + 1] = value;
                        },
                      ),
                    ),
                    Offstage(
                      offstage: isEdit,
                      child: Text(
                        '${ProjInfo[index + 1]}',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ))
              ],
            ));
      },
      separatorBuilder: (BuildContext context, int index) =>
          Container(height: 1.0, color: Colors.grey),
    );
  }

  Widget _auction() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: AuctionInfo.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(100, 8, 0, 8),
            height: 100,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Image(
                    image: AssetImage("assets/notFind.jpeg"),
                  ),
                ),
                Column(
                  children: [
                    Text('Name：${AuctionInfo[index][0]}'),
                    Text('Price：${AuctionInfo[index][1]}'),
                    Text('Message：${AuctionInfo[index][2]}'),
                  ],
                )
              ],
            ));
      },
      separatorBuilder: (BuildContext context, int index) =>
          Container(height: 1.0, color: Colors.grey),
    );
  }

  Widget _process(width) {

    return Column(children: [
      Container(
        height: 300,
        child: Center(
          child: Column(
            children: [
              Container(
                width: 0.6 * width,
                child: LinearPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: 20.0,
                  leading: new Text("7月16日"),
                  trailing: new Text("7月26日"),
                  percent: 0.4,
                  center: Text('7月20日(' + (0.4 * 100).toString() + '%)'),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.blue,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                child: FlatButton(
                    child: new Text('评分'),
                    onPressed: () {
                      _showRatingDialog();
                    }
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          color: Colors.white,
        ),
      )
    ]);
  }

  Widget _card1(width) {
    return Card(
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
                                builder: (context) => ApplyPage(ProjInfo[0],
                                    ProjInfo[1], ProjInfo[3], skills)));
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
                      return _detail();
                    else if (item == "竞价") {
                      return _auction();
                    } else
                      return _process(width);
                  }).toList(),
                ),
              ),
            ],
          )),
    );
  }

  Widget _card2() {
    return Stack(
      children: [
        Offstage(
          offstage: isManager,
          child: Card(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                    separatorBuilder: (BuildContext context, int index) =>
                        Container(height: 1.0, color: Colors.grey),
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
                    padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
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
                                    image: AssetImage("assets/notFind.jpeg"),
                                  ),
                                ),
                                Expanded(
                                    child: ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: entries2.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            height: 20,
                                            alignment: Alignment.center,
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
                    separatorBuilder: (BuildContext context, int index) =>
                        Container(height: 1.0, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
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
        body: Stack(
          children: [
            Offstage(
              offstage: !isLarge,
              child: Row(
                children: <Widget>[
                  Container(
                      width: 0.70 * width,
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                      child: _card1(0.7 * width)),
                  Container(
                      width: 0.30 * width,
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                      child: _card2()),
                ],
              ),
            ),
            Offstage(
              offstage: isLarge,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Container(
                        constraints:
                            BoxConstraints(minHeight: 100, maxHeight: 700),
//                        height: 700,
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: _card1(width)),
                    Container(
                        height: 500,
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: _card2()),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}



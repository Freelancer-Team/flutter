import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:freelancer_flutter/component/MyDrawer.dart';
import 'package:freelancer_flutter/pages/apply.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:freelancer_flutter/component/SkillChooseModal.dart';
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
  var _role = 0;
  var jobstate = 0;
  String token;
  bool isEdit = false;
  bool isEmployer = false;
  bool isEmployee = false;
  bool isLog = false;
  bool hasEmployee = false;
  TabController mController;
  List<String> tabTitles = ["详情", "竞价", "进度"];
  final List entries = ['名称', '描述', '薪资', '地址', '技能点', '截止时间', '联系方式'];
  List ProjInfo = [
    'ID',
    'Name',
    'Description',
    'Price',
    '登陆后查看',
    '1',
    '截止时间',
    '登陆后查看'
  ];
  var avgPrice;
  var lowestPrice;
  var employerRate = -1.0;
  var employeeRate = -1.0;
  var _type;
  final List entries2 = ['姓名', '联系方式', '邮箱'];
  List UserInfo = ['id', 'lyb', '54749110', '1@qq.com', '东川路800'];
  List AuctionInfo = [];
  List<String> skills = new List();
  List EmployerInfo = ['id', 'name', '登陆后查看', '登陆后查看'];
  List rating = ['暂无', '暂无'];

  var array;
  var array2;
  var array3;
  var array4;
  Future<http.Response> fetchPost() async {
    int uid = await StorageUtil.getIntItem("uid");
    int role = await StorageUtil.getIntItem("role");
    String _token = await StorageUtil.getStringItem('token');
    if (uid != null)
      setState(() {
        isLog = true;
        _uid = uid;
        _role = role;
        token = _token;
      });
    var url = "${Url.url_prefix}/getJob?id=" + ID;
    var response =
        await http.post(url, headers: {"Accept": "application/json"});
    final data = json.decode(response.body);
    setState(() {
      array = data;
      ProjInfo[0] = array['id'];
      ProjInfo[1] = array['title'];
      ProjInfo[2] = array['description'];
      ProjInfo[3] = array['price'];
      ProjInfo[6] = array['deadline'];
      _type = array['type'];
      EmployerInfo[0] = array['employerId'].toString();
      EmployerInfo[1] = array['employerName'];
      UserInfo[0] = array['employeeId'].toString();
      avgPrice = array['avgPrice'];
      lowestPrice = array['lowestPrice'];
      jobstate = array['state'];
      employerRate = array['employerRate'];
      employeeRate = array['employeeRate'];
      for (int i = 0; i < array['skills'].length; i++) {
        skills.add(array['skills'][i].toString());
      }
      if (_uid == array['employerId']) {
        isEmployer = true;
      }
      if (_uid == array['employeeId']) {
        isEmployee = true;
      }
      if(array['employeeId'] != 0){
        hasEmployee = true;
      }
    });

    url = "${Url.url_prefix}/getUser?id=" + EmployerInfo[0];
    response = await http.post(Uri.encodeFull(url),
        headers: {"Accept": "application/json", "Authorization": "$token"});
    final data2 = json.decode(response.body);
    setState(() {
      array2 = data2;
      if (array2['status'] != 500) {
        EmployerInfo[2] = array2['address'];
        EmployerInfo[3] = array2['phone'];
        ProjInfo[4] = array2['address'];
        ProjInfo[7] = array2['phone'];
      }
      if (array2['employerRate'] != null && array2['employerRate'] != 'NaN') {
        rating[0] = array2['employerRate'];
      }
    });

    if (hasEmployee && (isEmployer||_role == 1)) {
      url = "${Url.url_prefix}/getUser?id=" + UserInfo[0];
      response = await http.post(Uri.encodeFull(url),
          headers: {"Accept": "application/json", "Authorization": "$token"});
      final data3 = json.decode(response.body);
      setState(() {
        array3 = data3;
        UserInfo[1] = array3['name'];
        UserInfo[2] = array3['phone'];
        UserInfo[3] = array3['email'];
        if (array3['employeeRate'] != null && array3['employeeRate'] != 'NaN') {
          rating[1] = array3['employeeRate'];
        }
      });
    }
    if (isEmployer) {
      url = "${Url.url_prefix}/getAuction?jobId=" + ID;
      response = await http.post(Uri.encodeFull(url),
          headers: {"Accept": "application/json", "Authorization": "$token"});
      final data4 = json.decode(response.body);
      setState(() {
        array4 = data4;
        for (int i = 0; i < array4.length; i++) {
          AuctionInfo.add([
            array4[i]['userName'],
            array4[i]['price'],
            array4[i]['description'],
            array4[i]['type'],
            array4[i]['userId']
          ]);
          if(array4[i]['type'] == 0){
            AuctionInfo[i][3] ='时薪';
          }
          else {
            AuctionInfo[i][3] ='全部';
          }
        }
      });
    }
  }

  savePost() async {
    var url = "${Url.url_prefix}/saveJob";
    var response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": "$token"
        },
        body: json.encode(array));
  }

  assign(userId, userName) async {
    var url = "${Url.url_prefix}/assignJob";
    var res = await http.post(Uri.encodeFull(url),
        headers: {"Accept": "application/json", "Authorization": "$token"},
        body: {"userId": userId, "userName": userName, "jobId": ID});
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

  var ratingValue;
  String value() {
    if (ratingValue == null) {
      return '评分：4.5 分';
    } else {
      return '评分：$ratingValue  分';
    }
  }

  void _showRatingDialog() {
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            return SimpleDialog(
                title: Text('请评分'),
                contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
                children: [
                  Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(40.0, 0, 0, 0),
                            child: RatingBar(
                              value: 4.5,
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
                              maxRating: 5,
                              count: 5,
                            ),
                          ),
                          Text(value()),
                          FlatButton(
                              child: new Text('确定'),
                              onPressed: () {
                                if (isEmployer) {
                                  array['employerRate'] = ratingValue;
                                }
                                if (isEmployee) {
                                  array['employeeRate'] = ratingValue;
                                }
                                savePost();
                                Navigator.of(context).pop();
                              }),
                        ],
                      )),
                ]);
          });
        });
  }

  Widget skillBar() {
    FlutterToast flutterToast;
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

    _showSimpleDialog() {
      onSkillChange(var _skills) {
        setState(() {
          skills = _skills;
          array['skills'] =skills;
        });
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
                      skillChoose: this.skills,
                      onSkillChanged: onSkillChange,
                    ),
                  ]));
    }

    List<Widget> skillManageList = skills
        .map((skill) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.black54,
              ),
              child:
                  Text(skill, style: TextStyle(height: 1, color: Colors.white)),
            ))
        .toList();
    skillManageList.add(Container(
      child: SizedOverflowBox(
        size: Size(32, 32),
        alignment: Alignment.center,
        child: Offstage(
          offstage: !isEdit,
          child: IconButton(
            // action button
            icon: new Icon(Icons.add_circle),
            padding: const EdgeInsets.all(0),
            onPressed: () {
              _showSimpleDialog();
            },
          ),
        ),
      ),
    ));

    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Wrap(
        children: skillManageList,
      ),
    ));
  }

  Widget _detail() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 4)
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
                  Expanded(child: skillBar())
                ],
              ));
        else
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
                      child: Column(
                    children: [
                      Offstage(
                        offstage: !isEdit,
                        child: Column(
                          children: [
                            Offstage(
                              offstage: index == 1,
                              child: TextFormField(
                                key: Key('info'),
                                autofocus: true,
                                maxLines: 1,
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
                              offstage: index != 1,
                              child: TextFormField(
                                key: Key('info'),
                                autofocus: true,
                                maxLines: 5,
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
                          ],
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

  Widget _auction(width) {
    return Stack(
      children: [
        Offstage(
            offstage: !isEmployer,
            child: Stack(
              children: [
                Offstage(
                  offstage: hasEmployee,
                  child: Stack(
                    children: [
                      Offstage(
                        offstage: AuctionInfo.length != 0,
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                            ),
                            Center(
                              child: Text('暂无', style: TextStyle(fontSize: 22)),
                            )
                          ],
                        ),
                      ),
                      ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: AuctionInfo.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.fromLTRB(0.15 * width, 8, 0, 8),
                              height: 100,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        0, 0, 0.05 * width, 0),
                                    child: Image(
                                      image: AssetImage("assets/notFind.jpeg"),
                                    ),
                                  ),
                                  Container(
                                    width: 0.75 * width,
                                    child: Column(
                                      children: [
                                        Text('Name：${AuctionInfo[index][0]}'),
                                        Text('Price：${AuctionInfo[index][3]}:${AuctionInfo[index][1]}'),
                                        Text('Message：${AuctionInfo[index][2]}')
                                      ],
                                    ),
                                  ),
                                  MaterialButton(
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text('选Ta'),
                                    onPressed: () {
                                      showDialog<Null>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return new AlertDialog(
                                            title: new Text('确定让他接取你的工作？'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: new Text('取消'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: new Text('确定'),
                                                onPressed: () {
                                                  assign(
                                                      AuctionInfo[index][3]
                                                          .toString(),
                                                      AuctionInfo[index][0]);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                                ],
                              ));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Container(height: 1.0, color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Offstage(
                  offstage: !hasEmployee,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                      ),
                      Center(
                        child: Text('已有人接单', style: TextStyle(fontSize: 22)),
                      )
                    ],
                  ),
                )
              ],
            )),
        Offstage(
          offstage: isEmployer,
          child: Column(
            children: [
              Container(
                height: 150,
              ),
              Container(
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "当前平均价: $avgPrice",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "当前最低价: $lowestPrice",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _process(width) {
    return Column(children: [
      Offstage(
          offstage: isEmployee || isEmployer,
          child: Column(
            children: [
              Container(
                height: 200,
              ),
              Text("无法查看", style: TextStyle(fontSize: 22))
            ],
          )),
      Offstage(
        offstage: !isEmployee && !isEmployer,
        child: Container(
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
                Offstage(
                  offstage: isEmployer,
                  child: Column(
                    children: [
                      Offstage(
                        offstage: employeeRate != -1.0,
                        child: Container(
                          height: 50,
                          child: FlatButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: new Text('评分'),
                              onPressed: () {
                                _showRatingDialog();
                              }),
                        ),
                      ),
                      Offstage(
                          offstage: employeeRate == -1.0,
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(0.4 * width, 8, 0, 8),
                                child: RatingBar(
                                  value: employeeRate,
                                  size: 30,
                                  padding: 5,
                                  nomalImage: 'assets/star_nomal.png',
                                  selectImage: 'assets/star.png',
                                  selectAble: false,
                                  maxRating: 5,
                                  count: 5,
                                ),
                              ),
                              Text("你的评分：$employeeRate分"),
                              Offstage(
                                offstage: employerRate == -1.0,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0.4 * width, 8, 0, 8),
                                      child: RatingBar(
                                        value: employerRate,
                                        size: 30,
                                        padding: 5,
                                        nomalImage: 'assets/star_nomal.png',
                                        selectImage: 'assets/star.png',
                                        selectAble: false,
                                        maxRating: 5,
                                        count: 5,
                                      ),
                                    ),
                                    Text("雇主评分：$employerRate分")
                                  ],
                                ),
                              ),
                              Offstage(
                                  offstage: employeeRate != -1.0,
                                  child: Text("雇主未评分"))
                            ],
                          ))
                    ],
                  ),
                ),
                Offstage(
                  offstage: isEmployee,
                  child: Column(
                    children: [
                      Offstage(
                        offstage: employerRate != -1.0,
                        child: Container(
                          height: 50,
                          child: FlatButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: new Text('评分'),
                              onPressed: () {
                                _showRatingDialog();
                              }),
                        ),
                      ),
                      Offstage(
                          offstage: employerRate == -1.0,
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(0.4 * width, 8, 0, 8),
                                child: RatingBar(
                                  value: employerRate,
                                  size: 30,
                                  padding: 5,
                                  nomalImage: 'assets/star_nomal.png',
                                  selectImage: 'assets/star.png',
                                  selectAble: false,
                                  maxRating: 5,
                                  count: 5,
                                ),
                              ),
                              Text("你的评分：$employerRate分"),
                              Offstage(
                                offstage: employeeRate == -1.0,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0.4 * width, 8, 0, 8),
                                      child: RatingBar(
                                        value: employeeRate,
                                        size: 30,
                                        padding: 5,
                                        nomalImage: 'assets/star_nomal.png',
                                        selectImage: 'assets/star.png',
                                        selectAble: false,
                                        maxRating: 5,
                                        count: 5,
                                      ),
                                    ),
                                    Text("雇员评分：$employeeRate分")
                                  ],
                                ),
                              ),
                              Offstage(
                                  offstage: employeeRate != -1.0,
                                  child: Text("雇员未评分"))
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
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
            key: Key('bar'),
            toolbarHeight: 50,
            title: Text('${ProjInfo[1]}', key: Key('projectTitle')),
            centerTitle: false,
            actions: <Widget>[
              Offstage(
                  offstage: isEmployer,
                  child: Offstage(
                    offstage:  isEmployee,
                    child: FlatButton(
                      key: Key("apply"),
                      child: new Text(
                        '我想试试',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (hasEmployee) {
                          showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                    title: Text('已有人接单'),
                                    children: [
                                      FlatButton(
                                          child: new Text('确定'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                    ],
                                  ));
                        } else {
                          !isLog
                              ? Navigator.pushNamed(context, "/login")
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ApplyPage(
                                          ProjInfo[0],
                                          ProjInfo[1],
                                          ProjInfo[3],
                                          skills,
                                          _type)));
                        }
                      },
                    ),
                  )),
              Offstage(
                  offstage: !isEmployer || hasEmployee,
                  child: IconButton(
                    key: Key('edit'),
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
                    key: Key('save'),
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
                      return _auction(0.7 * width);
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
          offstage: isEmployer,
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
                                Container(
                                  height: 50,
                                  child: Text(
                                    '发布公司/个人',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
//                                Image(),
                                Container(
                                    height: 120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('名称：${EmployerInfo[1]}',
                                            style: TextStyle(fontSize: 16)),
                                        Text('地址：${EmployerInfo[2]}',
                                            style: TextStyle(fontSize: 16)),
                                        Text('联系方式：${EmployerInfo[3]}',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ))
                              ],
                            ));
                      else if (index == 1)
                        return Container(
                            alignment: Alignment.center,
                            height: 80,
                            child: Column(
                              children: [
                                Text('认证信息', style: TextStyle(fontSize: 20)),
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
                            height: 100,
                            child: Column(
                              children: [
                                Text('历史评分', style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '${rating[0]}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
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
          offstage: !isEmployer,
          child: Card(
              child: Stack(
            children: [
              Offstage(
                offstage: !hasEmployee,
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
                                        image:
                                            AssetImage("assets/notFind.jpeg"),
                                      ),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                            padding: const EdgeInsets.all(8),
                                            itemCount: entries2.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                height: 20,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    '${entries2[index]}: ${UserInfo[index + 1]}',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              );
                                            })),
                                  ],
                                ));
                          else
                            return Container(
                                alignment: Alignment.center,
                                height: 100,
                                child: Column(
                                  children: [
                                    Text('历史评分',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '${rating[1]}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Container(height: 1.0, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: hasEmployee,
                child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text('接单人', style: TextStyle(fontSize: 22)),
                        Text('暂无接单人', style: TextStyle(fontSize: 20))
                      ],
                    )),
              )
            ],
          )),
        )
      ],
    );
  }

  Widget _card3() {
    return Card(
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
                              Container(
                                height: 50,
                                child: Text(
                                  '发布公司/个人',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
//                                Image(),
                              Container(
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          '名称：${EmployerInfo[1]}',
                                          style: TextStyle(fontSize: 16)),
                                      Text('地址：${EmployerInfo[2]}',
                                          style: TextStyle(fontSize: 16)),
                                      Text('联系方式：${EmployerInfo[3]}',
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ))
                            ],
                          ));
                    else if (index == 1)
                      return Container(
                          alignment: Alignment.center,
                          height: 80,
                          child: Column(
                            children: [
                              Text('认证信息', style: TextStyle(fontSize: 20)),
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
                            children: [
                              Text('历史评分', style: TextStyle(fontSize: 20)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '${rating[0]}',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(height: 1.0, color: Colors.grey),
                ),
              ),

              Container(height: 1.0, color: Colors.grey),
              Container(
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
                          image:
                          AssetImage("assets/notFind.jpeg"),
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: entries2.length,
                              itemBuilder: (BuildContext context,
                                  int index) {
                                return Container(
                                  height: 20,
                                  alignment: Alignment.center,
                                  child: Text(
                                      '${entries2[index]}: ${UserInfo[index + 1]}',
                                      style: TextStyle(
                                          fontSize: 16)),
                                );
                              })),
                    ],
                  )),
              Container(height: 1.0, color: Colors.grey),
              Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: Column(
                    children: [
                      Text('历史评分',
                          style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${rating[1]}',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
                  Offstage(
                    offstage: hasEmployee,
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text('接单人', style: TextStyle(fontSize: 22)),
                            Text('暂无接单人', style: TextStyle(fontSize: 20))
                          ],
                        )),
                  )
                ],
              )
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            '项目详情',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          brightness: Brightness.light,
        ),
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
                      child: Stack(
                        children: [
                          Offstage(
                            offstage: _role == 1,
                            child: _card2(),
                          ),
                          Offstage(
                            offstage: _role == 0,
                            child: _card3(),
                          )
                        ],
                      )),
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
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: _card1(width)),
                    Container(
                        height: 750,
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: Stack(
                          children: [
                            Offstage(
                              offstage: _role == 1,
                              child: _card2(),
                            ),
                            Offstage(
                              offstage: _role == 0,
                              child: _card3(),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

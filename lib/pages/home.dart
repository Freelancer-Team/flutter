import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freelancer_flutter/component/CntForSuggest.dart';
import 'package:freelancer_flutter/component/quad_clipper.dart';
import 'package:freelancer_flutter/component/MyDrawer.dart';
import 'package:freelancer_flutter/pages/ProjDetails.dart';
import 'package:freelancer_flutter/pages/jobList.dart';
import 'package:freelancer_flutter/pages/publish.dart';
import 'package:freelancer_flutter/theme/light_color.dart';
import 'package:freelancer_flutter/theme/app_theme.dart';
import 'package:freelancer_flutter/component/Lists.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:http/http.dart'as http;
import 'dart:async';
import 'dart:convert';
import 'package:freelancer_flutter/component/config.dart';

class HomePage extends StatefulWidget{
  HomePage({Key key}) : super(key: key);

  State<StatefulWidget> createState(){
    return RecomendedPage();
  }
}

class RecomendedPage extends State<HomePage> {

  double width;
  bool isLog=false;

  List<Lists> categories = [
    Lists(text: '我要工作'),
    Lists(text: '我要雇人'),
  ];

  List RecA =[['1','1','1',1,'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png'],['2','2','2',2,'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png'],['3','3','3',3,'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png'],['4','4','4',4,'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png']];
  List RecB =[['1','1','1',1,'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png'],['2','2','2',2,'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png'],['3','3','3',3,'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png'],['4','4','4',4,'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png']];

  var array = [] ;
  Future<http.Response> fetchPost() async {
    int userId = 0;
    int uid = await StorageUtil.getIntItem("uid");
    if(uid!=null) setState(() {
      isLog=true;
      userId = uid;
    });

    var url = "${Url.url_prefix}/getSuggestJobs";
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    });
    final data = json.decode(response.body);
    setState(() {
      array = data;
      RecA[0][0] = array[0]['title'];
      RecA[0][1] = array[0]['price'];
      RecA[0][2] = array[0]['id'];
      RecA[0][3] = array[0]['employerId'];

      RecA[1][0] = array[1]['title'];
      RecA[1][1] = array[1]['price'];
      RecA[1][2] = array[1]['id'];
      RecA[1][3] = array[1]['employerId'];

      RecA[2][0] = array[2]['title'];
      RecA[2][1] = array[2]['price'];
      RecA[2][2] = array[2]['id'];
      RecA[2][3] = array[2]['employerId'];

      RecA[3][0] = array[3]['title'];
      RecA[3][1] = array[3]['price'];
      RecA[3][2] = array[3]['id'];
      RecA[3][3] = array[3]['employerId'];

      RecB[0][0] = array[4]['title'];
      RecB[0][1] = array[4]['price'];
      RecB[0][2] = array[4]['id'];
      RecA[0][3] = array[4]['employerId'];

      RecB[1][0] = array[5]['title'];
      RecB[1][1] = array[5]['price'];
      RecB[1][2] = array[5]['id'];
      RecA[1][3] = array[5]['employerId'];

      RecB[2][0] = array[6]['title'];
      RecB[2][1] = array[6]['price'];
      RecB[2][2] = array[6]['id'];
      RecA[2][3] = array[6]['employerId'];

      RecB[3][0] = array[7]['title'];
      RecB[3][1] = array[7]['price'];
      RecB[3][2] = array[7]['id'];
      RecA[3][3] = array[7]['employerId'];
    });
    getEmployerIcon();
  }

  void initState() {
    super.initState();
    fetchPost();
  }

  getEmployerIcon() async {
    for(int i = 0; i < 4; ++i){
      String url = "${Url.url_prefix}/getOnesIcon?userId=" + RecA[i][3].toString();
      final res = await http.get(url, headers: {"Accept": "application/json"});
      final data = json.decode(res.body);
      setState(() {
        RecA[i][4] = data[1];
      });
    }
    for(int i = 0; i < 4; ++i){
      String url = "${Url.url_prefix}/getOnesIcon?userId=" + RecB[i][3].toString();
      final res = await http.get(url, headers: {"Accept": "application/json"});
      final data = json.decode(res.body);
      setState(() {
        RecB[i][4] = data[1];
      });
    }
  }

  double getRadius() {
    return new Random().nextDouble() * 80 - 40;
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  Widget _categoryRow(
    String title,
    Color primary,
    Color textColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: LightColor.titleTextColor, fontWeight: FontWeight.bold),
          ),
//          _chip("See all", primary)
        ],
      ),
    );
  }

  Widget _featuredRowA() {
    return SingleChildScrollView(
//      scrollDirection: Axis.horizontal,
      child: Container(
        child: Wrap(
//          mainAxisAlignment: MainAxisAlignment.start,
//          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              key: Key('suggestOne'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecA[0][2])));
              },
             child:  _card(
                  primary: Colors.white,
//                  backWidget:
//                  _decorationContainerA(LightColor.lightOrange, getRadius(), getRadius()),
                  backWidget: _decorationContainerF(LightColor.lightOrange, LightColor.orange, getRadius(), getRadius()),
                  chipColor: LightColor.orange,
                  chipText1: RecA[0][0],
                  chipText2: RecA[0][1],
                  imgPath: RecA[0][4]
             ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecA[1][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.seeBlue,
                  backWidget: _decorationContainerB(Colors.white, getRadius(), getRadius()),
                  chipText1: RecA[1][0],
                  chipText2: RecA[1][1],
                  imgPath: RecA[1][4]
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecA[2][2])));
              },
              child:  _card(
                  primary: Colors.white,
                  chipColor: LightColor.lightOrange,
                  backWidget: _decorationContainerC(Colors.white, getRadius(), getRadius()),
                  chipText1: RecA[2][0],
                  chipText2: RecA[2][1],
                  imgPath: RecA[2][4]
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecA[3][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.seeBlue,
//                  backWidget: _decorationContainerD(LightColor.seeBlue, getRadius(), getRadius(),
//                      secondary: LightColor.lightseeBlue,
//                      secondaryAccent: LightColor.darkseeBlue),
                  backWidget: _decorationContainerE(
                    LightColor.lightpurple,
                    getRadius(),
                    getRadius(),
                    secondary: LightColor.lightseeBlue,
                  ),
                  chipText1: RecA[3][0],
                  chipText2: RecA[3][1],
                  imgPath: RecA[3][4]
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[0][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.lightOrange,
//                  backWidget: _decorationContainerD(
//                      LightColor.darkseeBlue, -100, -65,
//                      secondary: LightColor.lightseeBlue,
//                      secondaryAccent: LightColor.seeBlue),
                  backWidget: _decorationContainerF(LightColor.lightOrange, LightColor.orange, getRadius(), getRadius()),
                  chipText1: RecB[0][0],
                  chipText2: RecB[0][1],
                  imgPath: RecB[0][4]
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[1][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.seeBlue,
                  backWidget: _decorationContainerB(Colors.white, getRadius(), getRadius()),
                  chipText1: RecB[1][0],
                  chipText2: RecB[1][1],
                  imgPath: RecB[1][4]
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[2][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.lightOrange,
                  backWidget: _decorationContainerC(Colors.white, getRadius(), getRadius()),
                  chipText1: RecB[2][0],
                  chipText2: RecB[2][1],
                  imgPath: RecB[2][4]
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[3][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.seeBlue,
//                  backWidget: _decorationContainerA(
//                    Colors.orangeAccent,
//                    getRadius(),
//                    getRadius(),
//                  ),
                  backWidget: _decorationContainerE(
                    LightColor.lightpurple,
                    getRadius(),
                    getRadius(),
                    secondary: LightColor.lightseeBlue,
                  ),
                  chipText1: RecB[3][0],
                  chipText2: RecB[3][1],
                  imgPath: RecB[3][4]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featuredRowB() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[0][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.seeBlue,
//                  backWidget: _decorationContainerD(
//                      LightColor.darkseeBlue, -100, -65,
//                      secondary: LightColor.lightseeBlue,
//                      secondaryAccent: LightColor.seeBlue),
                  backWidget: _decorationContainerC(Colors.white, getRadius(), getRadius()),
                  chipText1: RecB[0][0],
                  chipText2: RecB[0][1],
                  imgPath:
                  "https://p.qqan.com/up/2020-9/2020941050205581.jpg"),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[1][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.lightpurple,
                  backWidget: _decorationContainerE(
                    LightColor.lightpurple,
                    getRadius(),
                    getRadius(),
                    secondary: LightColor.lightseeBlue,
                  ),
                  chipText1: RecB[1][0],
                  chipText2: RecB[1][1],
                  imgPath:
                  "https://p.qqan.com/up/2020-9/2020941050205581.jpg"),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[2][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.lightOrange,
                  backWidget: _decorationContainerF(
                      LightColor.lightOrange, LightColor.orange, getRadius(), getRadius()),
                  chipText1: RecB[2][0],
                  chipText2: RecB[2][1],
                  imgPath:
                  "https://p.qqan.com/up/2020-9/2020941050205581.jpg"),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[3][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.seeBlue,
//                  backWidget: _decorationContainerA(
//                    Colors.orangeAccent,
//                    getRadius(),
//                    getRadius(),
//                  ),
                  backWidget: _decorationContainerB(Colors.white, getRadius(), getRadius()),
                  chipText1: RecB[3][0],
                  chipText2: RecB[3][1],
                  imgPath:
                  "https://p.qqan.com/up/2020-9/2020941050205581.jpg"),
            ),
            ],
        ),
      ),
    );
  }

  Widget _card(
      {Color primary = Colors.redAccent,
      String imgPath,
      String chipText1 = '',
      String chipText2 = '',
      Widget backWidget,
      Color chipColor = LightColor.orange,
      bool isPrimaryCard = false}) {
    return Container(
        height: isPrimaryCard ? 180 : 180,
        width: MediaQuery.of(context).size.width > 1080 ? width * .23 : width * .43,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: primary.withAlpha(200),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: LightColor.lightpurple.withAlpha(20))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                backWidget,
                Positioned(
                    top: 20,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: NetworkImage(imgPath),
                    )),
                Positioned(
                  top: 85,
                  left: 10,
                  child: _cardInfo(chipText1, chipText2,
                      LightColor.titleTextColor, chipColor,
                      isPrimaryCard: isPrimaryCard),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _cardInfo(String title, String courses, Color textColor, Color primary,
      {bool isPrimaryCard = false}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        height: 85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10),
              width: MediaQuery.of(context).size.width > 1080 ? width * 0.23 : width * 0.43,
              alignment: Alignment.topCenter,

              child: Text(
                title,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isPrimaryCard ? Colors.white : textColor),
              ),
            ),
            _chip(courses, primary, height: 5, isPrimaryCard: isPrimaryCard)
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
      ),
    );
  }

  Widget _decorationContainerA(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: primary.withAlpha(255),
          ),
        ),
        _smallContainer(primary, 20, 40),
        Positioned(
          top: 20,
          right: -30,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        )
      ],
    );
  }

  Widget _decorationContainerB(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: LightColor.seeBlue.withAlpha(200),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SizedBox(width: width * 0.43, height: 75, child: Container(),),
          ),
        ),
        Positioned(
          top: -50,
          right: -50,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.shade200,
            child: CircleAvatar(radius: 30, backgroundColor: LightColor.seeBlue.withAlpha(200)),
          ),
        ),
        Positioned(
            top: 35,
            right: -40,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(
                    backgroundColor: LightColor.lightseeBlue, radius: 40)))
      ],
    );
  }

  Widget _decorationContainerC(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: LightColor.lightOrange.withAlpha(200),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SizedBox(width: width * 0.43, height: 75, child: Container(),),
          ),
        ),
        Positioned(
          top: -105,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: LightColor.orange.withAlpha(100),
          ),
        ),
        Positioned(
            top: 35,
            right: -40,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(
                    backgroundColor: LightColor.orange, radius: 40)
            )
        ),
        _smallContainer(
          LightColor.yellow,
          35,
          70,
        )
      ],
    );
  }

  Widget _decorationContainerD(Color primary, double top, double left,
      {Color secondary, Color secondaryAccent}) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: secondary,
          ),
        ),
        _smallContainer(LightColor.yellow, 18, 35, radius: 12),
        Positioned(
          top: 130,
          left: -50,
          child: CircleAvatar(
            radius: 80,
            backgroundColor: primary,
            child: CircleAvatar(radius: 50, backgroundColor: secondaryAccent),
          ),
        ),
        Positioned(
          top: -30,
          right: -40,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        )
      ],
    );
  }

  Widget _decorationContainerE(Color primary, double top, double left,
      {Color secondary}) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: LightColor.seeBlue.withAlpha(200),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SizedBox(width: width * 0.43, height: 75, child: Container(),),
          ),
        ),
        Positioned(
          top: -105,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: primary.withAlpha(100),
          ),
        ),
//        Positioned(
//            top: 35,
//            right: -40,
//            child: ClipRect(
//                clipper: QuadClipper(),
//                child: CircleAvatar(backgroundColor: primary, radius: 40))),
        Positioned(
            top: 45,
            right: -30,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(backgroundColor: secondary, radius: 30))),
        _smallContainer(LightColor.yellow, 15, 90, radius: 5)
      ],
    );
  }

  Widget _decorationContainerF(
      Color primary, Color secondary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: LightColor.lightOrange.withAlpha(200),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SizedBox(width: width * 0.43, height: 75, child: Container(),),
          ),
        ),
        Positioned(
            top: 25,
            right: -20,
            child: RotatedBox(
              quarterTurns: 1,
              child: ClipRect(
                  clipper: QuadClipper(),
                  child: CircleAvatar(
                      backgroundColor: primary.withAlpha(200), radius: 50)),
            )),
        Positioned(
            top: 35,
            right: -8,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(
                    backgroundColor: secondary.withAlpha(100), radius: 40))),
        _smallContainer(LightColor.yellow, 15, 90, radius: 5)
      ],
    );
  }

  Positioned _smallContainer(Color primary, double top, double left,
      {double radius = 10}) {
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primary.withAlpha(255),
        ));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Freelancer',
            key: Key('title'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
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
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 100,
                    child: MaterialButton(
                      key: Key('hirebutton'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      child: Text(
                        '我要雇人',
                        key: Key('hiretext'),
                        style: TextStyle(fontSize: 26),
                      ),
                      onPressed: () {
                       isLog ? Navigator.push(context, MaterialPageRoute(builder: (context) => PublishPage())) : Navigator.pushNamed(context, "/login");
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    child: MaterialButton(
                      key: Key('workbutton'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      child: Text(
                        '我要工作',
                        key: Key('worktext'),
                        style: TextStyle(fontSize: 26),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => JobListPage()));
                      },
                    ),
                  ),
                ],
              ),
            ),

            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 0),
                    _categoryRow(
                        "Recommended", LightColor.orange, LightColor.orange),
                    _featuredRowA(),
                    SizedBox(height: 0),
//                    _categoryRow(
//                        "Featured", LightColor.purple, LightColor.darkpurple),
//                    _featuredRowB(),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:freelancer_flutter/component/quad_clipper.dart';
import 'package:freelancer_flutter/component/MyDrawer.dart';
import 'package:freelancer_flutter/pages/ProjDetails.dart';
import 'package:freelancer_flutter/theme/light_color.dart';
import 'package:freelancer_flutter/component/Lists.dart';
import 'package:http/http.dart'as http;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return RecomendedPage();
  }
}

class RecomendedPage extends State<HomePage> {
//  RecomendedPage({Key key}) : super(key: key);

  double width;

  List<Lists> categories = [
    Lists(text: '我要工作'),
    Lists(text: '我要雇人'),
  ];

  List RecA =[['1','1','1'],['2','2','2'],['3','3','3'],['4','4','4']];
  List RecB =[['1','1','1'],['2','2','2'],['3','3','3'],['4','4','4']];

  var array = [] ;
  Future<http.Response> fetchPost() async {
    var url = "http://localhost:8080/getJobs";
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    });
    final data = json.decode(response.body);
    setState(() {
      array = data;
      RecA[0][0] = array[0]['title'];
      RecA[0][1] = array[0]['price'];
      RecA[0][2] = array[0]['id'];
      RecA[1][0] = array[1]['title'];
      RecA[1][1] = array[1]['price'];
      RecA[1][2] = array[1]['id'];
      RecA[2][0] = array[2]['title'];
      RecA[2][1] = array[2]['price'];
      RecA[2][2] = array[2]['id'];
      RecA[3][0] = array[3]['title'];
      RecA[3][1] = array[3]['price'];
      RecA[3][2] = array[3]['id'];
      RecB[0][0] = array[4]['title'];
      RecB[0][1] = array[4]['price'];
      RecB[0][2] = array[4]['id'];
      RecB[1][0] = array[5]['title'];
      RecB[1][1] = array[5]['price'];
      RecB[1][2] = array[5]['id'];
      RecB[2][0] = array[6]['title'];
      RecB[2][1] = array[6]['price'];
      RecB[2][2] = array[6]['id'];
      RecB[3][0] = array[7]['title'];
      RecB[3][1] = array[7]['price'];
      RecB[3][2] = array[7]['id'];
    });
    return response;
  }

  void initState() {
    super.initState();
    fetchPost();
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
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecA[0][2])));
              },
             child:  _card(
                  primary: LightColor.orange,
                  backWidget:
                  _decorationContainerA(LightColor.lightOrange, 50, -30),
                  chipColor: LightColor.orange,
                  chipText1: RecA[0][0],
                  chipText2: RecA[0][1],
                  isPrimaryCard: true,
                  imgPath:
                  "https://jshopping.in/images/detailed/591/ibboll-Fashion-Mens-Optical-Glasses-Frames-Classic-Square-Wrap-Frame-Luxury-Brand-Men-Clear-Eyeglasses-Frame.jpg"),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecA[1][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.seeBlue,
                  backWidget: _decorationContainerB(Colors.white, 90, -40),
                  chipText1: RecA[1][0],
                  chipText2: RecA[1][1],
                  imgPath:
                  "https://hips.hearstapps.com/esquireuk.cdnds.net/16/39/980x980/square-1475143834-david-gandy.jpg?resize=480:*"),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecA[2][2])));
              },
              child:  _card(
                  primary: Colors.white,
                  chipColor: LightColor.lightOrange,
                  backWidget: _decorationContainerC(Colors.white, 50, -30),
                  chipText1: RecA[2][0],
                  chipText2: RecA[2][1],
                  imgPath:
                  "https://www.visafranchise.com/wp-content/uploads/2019/05/patrick-findaro-visa-franchise-square.jpg"),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecA[3][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.seeBlue,
                  backWidget: _decorationContainerD(LightColor.seeBlue, -50, 30,
                      secondary: LightColor.lightseeBlue,
                      secondaryAccent: LightColor.darkseeBlue),
                  chipText1: RecA[3][0],
                  chipText2: RecB[3][1],
                  imgPath:
                  "https://d1mo3tzxttab3n.cloudfront.net/static/img/shop/560x580/vint0080.jpg"),
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
                  primary: LightColor.seeBlue,
                  chipColor: LightColor.seeBlue,
                  backWidget: _decorationContainerD(
                      LightColor.darkseeBlue, -100, -65,
                      secondary: LightColor.lightseeBlue,
                      secondaryAccent: LightColor.seeBlue),
                  chipText1: RecB[0][0],
                  chipText2: RecB[0][1],
                  isPrimaryCard: true,
                  imgPath:
                  "https://www.reiss.com/media/product/946/218/silk-paisley-printed-pocket-square-mens-morocco-in-pink-red-20.jpg?format=jpeg&auto=webp&quality=85&width=1200&height=1200&fit=bounds"),
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
                    90,
                    -40,
                    secondary: LightColor.lightseeBlue,
                  ),
                  chipText1: RecB[1][0],
                  chipText2: RecB[1][1],
                  imgPath:
                  "https://i.dailymail.co.uk/i/pix/2016/08/05/19/36E9139400000578-3725856-image-a-58_1470422921868.jpg"),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[2][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.lightOrange,
                  backWidget: _decorationContainerF(
                      LightColor.lightOrange, LightColor.orange, 50, -30),
                  chipText1: RecB[2][0],
                  chipText2: RecB[2][1],
                  imgPath:
                  "https://www.reiss.com/media/product/945/066/03-2.jpg?format=jpeg&auto=webp&quality=85&width=632&height=725&fit=bounds"),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(RecB[3][2])));
              },
              child:   _card(
                  primary: Colors.white,
                  chipColor: LightColor.seeBlue,
                  backWidget: _decorationContainerA(
                    Colors.white,
                    -50,
                    30,
                  ),
                  chipText1: RecB[3][0],
                  chipText2: RecB[3][1],
                  imgPath:
                  "https://img.alicdn.com/imgextra/i4/52031722/O1CN0165X68s1OaiaYCEX6U_!!52031722.jpg"),
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
        height: isPrimaryCard ? 190 : 180,
        width: isPrimaryCard ? width * .32 : width * .32,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                  bottom: 10,
                  left: 10,
                  child: _cardInfo(chipText1, chipText2,
                      LightColor.titleTextColor, chipColor,
                      isPrimaryCard: isPrimaryCard),
                )
              ],
            ),
          ),
        ));
  }

  Widget _cardInfo(String title, String courses, Color textColor, Color primary,
      {bool isPrimaryCard = false}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            width: width * .32,
            alignment: Alignment.topCenter,

            child: Text(
              title,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isPrimaryCard ? Colors.white : textColor),
            ),
          ),
          SizedBox(height: 5),
          _chip(courses, primary, height: 5, isPrimaryCard: isPrimaryCard)
        ],
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
          top: -65,
          right: -65,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.blue.shade100,
            child: CircleAvatar(radius: 30, backgroundColor: primary),
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
                    backgroundColor: LightColor.orange, radius: 40))),
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
          top: -105,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: primary.withAlpha(100),
          ),
        ),
        Positioned(
            top: 40,
            right: -25,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(backgroundColor: primary, radius: 40))),
        Positioned(
            top: 45,
            right: -50,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(backgroundColor: secondary, radius: 50))),
        _smallContainer(LightColor.yellow, 15, 90, radius: 5)
      ],
    );
  }

  Widget _decorationContainerF(
      Color primary, Color secondary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
            top: 25,
            right: -20,
            child: RotatedBox(
              quarterTurns: 1,
              child: ClipRect(
                  clipper: QuadClipper(),
                  child: CircleAvatar(
                      backgroundColor: primary.withAlpha(100), radius: 50)),
            )),
        Positioned(
            top: 34,
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
          brightness: Brightness.light,
        ),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 100,
                    child: MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      child: Text(
                        '我要雇人',
                        style: TextStyle(fontSize: 26),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/login");
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    child: MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      child: Text(
                        '我要工作',
                        style: TextStyle(fontSize: 26),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/login");
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
                    _categoryRow(
                        "Featured", LightColor.purple, LightColor.darkpurple),
                    _featuredRowB(),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}

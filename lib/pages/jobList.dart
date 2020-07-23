import 'package:flutter/material.dart';
import 'package:freelancer_flutter/component/MyDrawer.dart';
import 'package:freelancer_flutter/component/filters_screen.dart';
import 'package:freelancer_flutter/component/hotel_app_theme.dart';
import 'package:freelancer_flutter/component/hotel_list_view.dart';
import 'package:freelancer_flutter/pages/ProjDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:freelancer_flutter/component/config.dart';

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Job> jobList = [];
  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    getJobs();
  }

//  var array = [];
////  Future<http.Response> fetchPost() async {
////    final response = await http.get('${Url.url_prefix}/getJobs');
////    final data = json.decode(response.body);
////    setState(() {
////      array = data;
////    });
////  }

  getJobs() async {
    List<Job> jobs = [];
    var response = [];
      final res = await http.get('${Url.url_prefix}/getJobs');
      final data = json.decode(res.body);
      response = data;
      for(int i = 0; i < response.length; ++i){
        List<String> skills = [];
        for(int j = 0; j < response[i]['skills'].length; ++j){
          skills.add(response[i]['skills'][j].toString());
        }
        jobs.add(Job(response[i]['id'], response[i]['title'], response[i]['description'], skills, response[i]['price']));
      }
      print(data[0]);


    setState(() {
      jobList = jobs;
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      resizeToAvoidBottomInset: false,
//      appBar: AppBar(
//        title: Text('项目列表',
//          style: TextStyle(
//            fontSize: 30.0,
//          ),
//        ),
//        centerTitle: true,
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            color: Colors.blue[900],
//          ),
//        ),
//        brightness: Brightness.light,
//      ),
//      drawer: MyDrawer(),
//      body: Expanded(
////        child: SingleChildScrollView(
////          controller: _scrollController,
////          headerSliverBuilder:
////              (BuildContext context, bool innerBoxIsScrolled) {
////            return <Widget>[
////              SliverList(
////                delegate: SliverChildBuilderDelegate(
////                        (BuildContext context, int index) {
////                      return Column(
////                        children: <Widget>[
////                          getSearchBarUI(),
////                        ],
////                      );
////                    }, childCount: 1),
////              ),
////              SliverPersistentHeader(
////                pinned: true,
////                floating: true,
////                delegate: ContestTabHeader(
////                  getFilterBarUI(),
////                ),
////              ),
////            ];
////          },
//          child:
//          Container(
//            color: HotelAppTheme.buildLightTheme().backgroundColor,
//            child: ListView.builder(
//              itemCount: jobList.length,
//              padding: const EdgeInsets.only(top: 8),
//              scrollDirection: Axis.vertical,
//              itemBuilder: (BuildContext context, int index) {
//                final int count =
//                jobList.length > 10 ? 10 : jobList.length;
//                final Animation<double> animation =
//                Tween<double>(begin: 0.0, end: 1.0).animate(
//                    CurvedAnimation(
//                        parent: animationController,
//                        curve: Interval(
//                            (1 / count) * index, 1.0,
//                            curve: Curves.fastOutSlowIn)));
//                animationController.forward();
//                return HotelListView(
//                  callback: () {},
//                  jobData: jobList[index],
//                  animation: animation,
//                  animationController: animationController,
//                );
//              },
//            ),
//          ),
//        ),
//
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
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
                    getAppBarUI(),
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
                              floating: true,
                              delegate: ContestTabHeader(
                                getFilterBarUI(),
                              ),
                            ),
                          ];
                        },
                        body: Container(
                          color:
                          HotelAppTheme.buildLightTheme().backgroundColor,
                          child: ListView.builder(
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
                              return HotelListView(
                                callback: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProjDetails(jobList[index].projectId)));},
                                jobData: jobList[index],
                                animation: animation,
                                animationController: animationController,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
//        color: HotelAppTheme.buildLightTheme().backgroundColor,
        color: Colors.blue[900],
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: Key('back'),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, color: Colors.white,),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '项目列表',
                  key: Key("joblist"),
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
//                  Material(
//                    color: Colors.transparent,
//                    child: InkWell(
//                      borderRadius: const BorderRadius.all(
//                        Radius.circular(32.0),
//                      ),
//                      onTap: () {},
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Icon(Icons.favorite_border),
//                      ),
//                    ),
//                  ),
//                  Material(
//                    color: Colors.transparent,
//                    child: InkWell(
//                      borderRadius: const BorderRadius.all(
//                        Radius.circular(32.0),
//                      ),
//                      onTap: () {},
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Icon(Icons.watch_later),
//                      ),
//                    ),
//                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
                    onChanged: (String txt) {},
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
          color: HotelAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${jobList.length} jobs found',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
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
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FiltersScreen(),
                            fullscreenDialog: true),
                      );
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
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
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
    return false;
  }
}

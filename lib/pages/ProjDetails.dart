import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freelancer_flutter/component/MyDrawer.dart';

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
  TabController mController;
  List<String> tabTitles;
  final List<String> entries = <String>['描述', '薪资', '地址','人数', '联系方式'];
  final List<List<String>> entries2 = <List<String>>[
    ['name1', 'price1', 'message1'],
    ['name2', 'price2', 'message2']
  ];

  @override
  void initState() {
    super.initState();
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
                          title: Text('Freelancer'),
                          centerTitle: false,
                          actions: <Widget>[
                            FlatButton(
                              child: new Text(
                                '我想试试',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {},
                            ),
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
                                          padding: const EdgeInsets.fromLTRB(16,8,8,8),
                                          alignment: Alignment.centerLeft,
                                          height: 60,
                                          child: Text('${entries[index]}：',
                                          style: TextStyle(fontSize: 18),),
                                        );
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
                                      itemCount: entries2.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            alignment: Alignment.centerLeft,
                                            height: 100,
                                            child: Column(
                                              children: [
                                                Text(
                                                    'Name：${entries2[index][0]}'),
                                                Text(
                                                    'Price：${entries2[index][1]}'),
                                                Text(
                                                    'Message：${entries2[index][2]}'),
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
                  )
              ),
          Container(
            width: 0.25 * width,
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              //创建质感设计卡片
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
                                      Text('发布公司/个人',
                                      style: TextStyle(fontSize: 22),),
//                                Image(),
                                      Text('name')
                                    ],
                                  ));
                            else if (index == 1)
                              return Container(
                                  alignment: Alignment.center,
                                  height: 80,
                                  child: Column(
                                    children: [Text('认证信息')],
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
              )
          ),
            ],
          ),
        ));
  }
}

class SmallScreen extends State<ProjDetails>
    with SingleTickerProviderStateMixin {
  TabController mController;
  List<String> tabTitles;
  final List<String> entries = <String>['描述', '薪资', '地址','人数', '联系方式'];
  final List<List<String>> entries2 = <List<String>>[
    ['name1', 'price1', 'message1'],
    ['name2', 'price2', 'message2']
  ];

  @override
  void initState() {
    super.initState();
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
                  height: 500,
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                          toolbarHeight: 50,
                          title: Text('Freelancer'),
                          centerTitle: false,
                          actions: <Widget>[
                            FlatButton(
                              child: new Text(
                                '我想试试',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {},
                            ),
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
                                          alignment: Alignment.centerLeft,
                                          height: 60,
                                          child: Text('${entries[index]}：',
                                          style: TextStyle(fontSize: 18),),
                                        );
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
                                      itemCount: entries2.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            alignment: Alignment.centerLeft,
                                            height: 100,
                                            child: Column(
                                              children: [
                                                Text(
                                                    'Name：${entries2[index][0]}'),
                                                Text(
                                                    'Price：${entries2[index][1]}'),
                                                Text(
                                                    'Message：${entries2[index][2]}'),
                                              ],
                                            ));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                          Container(
                                              height: 1.0,
                                              color: Colors.grey ),
                                    );
                                }).toList(),
                              ),
                            ),
                          ],
                        )),
                  )
              ),
              Container(
                height: 450,
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
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
                                      Text('发布公司/个人',
                                      style: TextStyle(fontSize: 20),),
//                                Image(),
                                      Text('name')
                                    ],
                                  ));
                            else if (index == 1)
                              return Container(
                                  alignment: Alignment.center,
                                  height: 80,
                                  child: Column(
                                    children: [Text('认证信息')],
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
          ),
        ));
  }
}

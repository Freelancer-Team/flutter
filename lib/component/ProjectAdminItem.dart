import 'hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:date_format/date_format.dart';
import 'package:freelancer_flutter/component/StateCard.dart';

class ProjectAdminItem extends StatelessWidget {
  const ProjectAdminItem(
      {Key key,
        this.jobData,
        this.animationController,
        this.animation,
        this.callback,
        this.navigateToEmployer,
        this.toggleCallback
      })
      : super(key: key);

  final VoidCallback callback;
  final VoidCallback navigateToEmployer;
  final Function(int) toggleCallback;
  final Job jobData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  callback();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              color: HotelAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 130),
                                              child:
                                                Text(
                                                  jobData.projectName,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    navigateToEmployer();
                                                  },
                                                  child: Chip(
                                                    label: Text(jobData.employerName),
                                                    avatar: CircleAvatar(
                                                      child: Icon(Icons.person, size: 20,),
                                                    ),
                                                    labelPadding: EdgeInsets.only(left: 8, right: 10),
                                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(left: 15),
                                                  child: Chip(
                                                    label: Text(formatDate(DateTime.parse(jobData.publishTime.replaceAll('.', '-')), [yyyy, '-', mm, '-', dd])),
                                                    avatar: CircleAvatar(
                                                      child: Icon(Icons.query_builder, size: 20,),
                                                    ),
                                                    labelPadding: EdgeInsets.only(left: 8, right: 10),
                                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                  ),
                                                ),
                                                StateCard(state: jobData.state, date: jobData.publishTime,)
                                              ],
                                            ),
                                            Text(
                                              jobData.description,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey
                                                      .withOpacity(0.8)),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 4),
                                              child: Wrap(
                                                children: jobData.skills.map((skill) => Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
                                                  margin: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    color: Colors.black54,
                                                  ),
                                                  child: Text(skill,style: TextStyle(height: 1,fontSize: 14, color: Colors.white.withOpacity(0.8)),),
                                                )).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 14, bottom: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          getPriceText(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 0.8),
                                          child: Text(
                                            getPriceType(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: MyToggleSwitch(state: jobData.state, toggleCallback: toggleCallback,)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String getPriceText() {
    if(jobData.minPrice == jobData.maxPrice){
      return '\$${jobData.minPrice}';
    }
    else return '\$${jobData.minPrice} - \$${jobData.maxPrice}';
  }

  String getPriceType() {
    if(jobData.priceType == 0){
      return '美元';
    }
    else return '美元 每小时';
  }
}

class MyToggleSwitch extends StatelessWidget{
  const MyToggleSwitch({Key key, this.state, this.toggleCallback})
      : super(key: key);

  final int state;
  final Function(int) toggleCallback;

  // flutter更新组件状态时，只更新最底部最小的部分，由于initialLabelIndex是在initialState中使用的，initialState不重复调用，
  // 因此toggleSwitch状态不会自动更新，此处通过为不同内容加上不同的父组件包裹，强制重新初始化一个新的toggleSwitch，解决了状态更新问题。
  @override
  Widget build(BuildContext context) {
    switch (state) {
      case -3:
        {
          return ToggleSwitch(
              minWidth: 90.0,
              initialLabelIndex: -1,
              cornerRadius: 16.0,
              activeFgColor: Colors.white,
              activeBgColor: Colors.grey,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              labels: ['正常', '禁用'],
              activeBgColors: [Colors.blue, Colors.pink],
              onToggle: (index) {
                toggleCallback(index);
              },
          );
        }
        break;
      case -1:
        {
          return SizedBox(
            child: new ToggleSwitch(
              minWidth: 90.0,
              initialLabelIndex: 1,
              cornerRadius: 16.0,
              activeFgColor: Colors.white,
              activeBgColor: Colors.grey,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              labels: ['正常', '禁用'],
              activeBgColors: [Colors.blue, Colors.pink],
              onToggle: (index) {
                toggleCallback(index);
              },
            ),
          );
        }
        break;
      case 0:
        {
          return Container(
            child: new ToggleSwitch(
              minWidth: 90.0,
              initialLabelIndex: 0,
              cornerRadius: 16.0,
              activeFgColor: Colors.white,
              activeBgColor: Colors.grey,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              labels: ['正常', '禁用'],
              activeBgColors: [Colors.blue, Colors.pink],
              onToggle: (index) {
                toggleCallback(index);
              },
            ),
          );
        }
        break;
      case -2:
      case 1:
      case 2:
        {
          return new AbsorbPointer(
            child: new ToggleSwitch(
              minWidth: 90.0,
              initialLabelIndex: 0,
              cornerRadius: 16.0,
              activeFgColor: Colors.white,
              activeBgColor: Colors.grey.withOpacity(0.5),
              inactiveBgColor: Colors.grey.withOpacity(0.5),
              inactiveFgColor: Colors.white,
              labels: ['正常', '禁用'],
              activeBgColors: [Colors.blue.withOpacity(0.5), Colors.pink.withOpacity(0.5)],
              onToggle: (index) {
                toggleCallback(index);
              },
            ),
          );
        }
        break;
    }
    return null;
  }
}

class Job {
  Job(
      this.projectId,
      this.projectName,
      this.employerId,
      this.employerName,
      this.description,
      this.skills,
      this.priceType,
      this.minPrice,
      this.maxPrice,
      this.state,    //分类情况见StateCard.dart
      this.publishTime,
      this.deadline
      );
  final String projectId;
  final String projectName;
  final int employerId;
  final String employerName;
  final String description;
  final List<String> skills;
  final int priceType;  //0为固定价格项目，1为时薪项目
  final int minPrice;
  final int maxPrice;
  int state;
  final String publishTime;
  final String deadline;
}

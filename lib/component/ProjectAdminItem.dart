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
        this.toggleCallback
      })
      : super(key: key);

  final VoidCallback callback;
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
                                                Chip(
                                                  label: Text(jobData.employerName),
                                                  avatar: CircleAvatar(
                                                    child: Icon(Icons.person, size: 20,),
                                                  ),
                                                  labelPadding: EdgeInsets.only(left: 8, right: 10),
                                                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(left: 15),
                                                  child: Chip(
                                                    label: Text(formatDate(DateTime.parse(jobData.deadline), [yyyy, '-', mm, '-', dd])),
                                                    avatar: CircleAvatar(
                                                      child: Icon(Icons.query_builder, size: 20,),
                                                    ),
                                                    labelPadding: EdgeInsets.only(left: 8, right: 10),
                                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                  ),
                                                ),
                                                StateCard(state: jobData.state, date: jobData.deadline,)
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
                          child: getToggleSwitch()
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

  Widget getToggleSwitch() {
    int index = 0;
    double opacity = 1;
    bool _absorbing = false;
    switch (jobData.state) {
      case -3:
        {
          index = -1;
        }
        break;
      case -1:
        {
          index = 1;
        }
        break;
      case 0:{}
        break;
      case -2:
      case 1:
      case 2:
        {
          _absorbing = true;
          opacity = 0.5;
        }
        break;
    }
    return AbsorbPointer(
      absorbing: _absorbing,
      child: ToggleSwitch(
        minWidth: 90.0,
        initialLabelIndex: index,
        cornerRadius: 16.0,
        activeFgColor: Colors.white,
        activeBgColor: Colors.grey.withOpacity(opacity),
        inactiveBgColor: Colors.grey.withOpacity(opacity),
        inactiveFgColor: Colors.white,
        labels: ['正常', '禁用'],
        activeBgColors: [Colors.blue.withOpacity(opacity), Colors.pink.withOpacity(opacity)],
        onToggle: (index) {
//          print('switched to: $index');
          toggleCallback(index);
        },
      ),
    );
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
  final String deadline;
}

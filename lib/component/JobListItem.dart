import 'hotel_app_theme.dart';
import 'package:flutter/material.dart';

class HotelListView extends StatelessWidget {
  const HotelListView(
      {Key key,
      this.jobData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
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
                                            Text(
                                              jobData.projectName,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 3, right: 7.0, top: 4.0, bottom: 4.0),
                                              margin: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15.0),
                                                color: Colors.grey.withOpacity(0.3),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.restore, size: 18,),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 3),
                                                    child: Text(
                                                      jobData.deadline,
                                                      style: TextStyle(height: 1,fontSize: 14,)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Wrap(
                                              children: <Widget>[
                                                Text(jobData.description,
                                                softWrap: true,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                              ],
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
                          top: -7,
                          right: 0,
                          child: PopupMenuButton<Choice>( // overflow menu
                            itemBuilder: (BuildContext context) {
                              return choices.map<PopupMenuItem<Choice>>((Choice choice) {
                                return PopupMenuItem<Choice>(
                                  value: choice,
                                  child: new ListTile(
                                    leading: Icon(choice.icon),
                                    title: Text(choice.title),
                                  ),
                                );
                              }).toList();
                            },
                          ),
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

class Job {
  Job(
      this.projectId,
      this.projectName,
      this.description,
      this.skills,
      this.priceType,
      this.minPrice,
      this.maxPrice,
      this.deadline
      );
  final String projectId;
  final String projectName;
  final String description;
  final List<String> skills;
  final int priceType;  //0为固定价格项目，1为时薪项目
  final int minPrice;
  final int maxPrice;
  final String deadline;
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: '添加至我的收藏', icon: Icons.star),
  Choice(title: '不感兴趣', icon: Icons.feedback),
];

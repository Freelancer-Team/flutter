import 'hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  margin: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 4.0),
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
                                    padding: const EdgeInsets.only(
                                        right: 1),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
//                                        Icon(Icons.more_horiz),
                                        PopupMenuButton<Choice>( // overflow menu
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
                                        Padding(
                                          padding: EdgeInsets.only(right: 13),
                                          child: Text(
                                            '${jobData.price}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
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
}


class Job {
  Job(
      this.projectId,
      this.projectName,
      this.description,
      this.skills,
      this.price
      );
  final String projectId;
  final String projectName;
  final String description;
  final List<String> skills;
  final String price;
}

/*假数据在这里*/
List<Job> fakeJobs = [
  Job('1', 'ABCDEFGH', 'wajgiajdigjaoijgoiaagjoaijgiajgoiajgajo', ['web','python','C++'], '130'),
  Job('1', 'ABCDEFGH', 'wajgiajdigjaoijgoiaagjoaijgiajgoiajgajo', ['web','OpenGL'], '120'),
  Job('1', 'ABCDEFGH', 'wajgiajdigjaoijgoiaagjoaijgiajgoiajgajo', ['web','Dart'], '30'),
  Job('1', 'ABCDEFGH', 'wajgiajdigjaoijgoiaagjoaijgiajgoiajgajo', ['web'], '10'),
  Job('1', 'ABCDEFGH', 'wajgiajdigjaoijgoiaagjoaijgiajgoiajgajo', ['web'], '190'),
  Job('1', 'ABCDEFGH', 'wajgiajdigjaoijgoiaagjoaijgiajgoiajgajo', ['web'], '230'),
  Job('1', 'ABCDEFGH', 'wajgiajdigjaoijgoiaagjoaijgiajgoiajgajo', ['web'], '60'),
  Job('1', 'ABCDEFGH', 'wajgiajdigjaoijgoiaagjoaijgiajgoiajgajo', ['web'], '180'),
];

/// This is the stateless widget that the main application instantiates.
class JobList extends StatelessWidget {
  final List<Job> jobs;

  JobList({this.jobs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                FlatButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: '个人信息', icon: Icons.account_circle),
  Choice(title: '我的项目', icon: Icons.assignment),
  Choice(title: '私信', icon: Icons.email),
];

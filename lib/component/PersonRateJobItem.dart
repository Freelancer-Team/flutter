import 'hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PersonRateJobItem extends StatelessWidget {
  const PersonRateJobItem(
      {Key key,
        this.jobData,
        this.isEmployer,
        this.animationController,
        this.animation,
        this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Job jobData;
  final bool isEmployer;
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
                    child: Container(
                      color: HotelAppTheme.buildLightTheme()
                          .backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
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
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 3, right: 7.0, top: 4.0, bottom: 4.0),
                                  margin: const EdgeInsets.only(right: 12.0, top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle, size: 16, color: Colors.black54,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3),
                                        child: Text(
                                            jobData.finishTime,
                                            style: TextStyle(height: 1.2, fontSize: 14,)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 3, right: 7.0, top: 4.0, bottom: 4.0),
                                  margin: const EdgeInsets.only(right: 6.0, top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SmoothStarRating(
                                          allowHalfRating: false,
                                          onRated: (v) {},
                                          starCount: 5,
                                          rating: isEmployer? jobData.employeeRate : jobData.employerRate,
                                          size: 16,
                                          isReadOnly:true,
                                          color: Colors.black54,
                                          borderColor: Colors.black54,
                                          spacing:0.0
                                      ),
//                                      Padding(
//                                        padding: EdgeInsets.only(left: 4),
//                                        child: Text(
//                                            jobData.employerRate.toString(),
//                                            style: TextStyle(height: 1.2, fontSize: 14,)
//                                        ),
//                                      ),
//                                      Padding(
//                                        padding: EdgeInsets.only(left: 1),
//                                        child: Text(
//                                            '分',
//                                            style: TextStyle(height: 1.2, fontSize: 13,)
//                                        ),
//                                      )
                                    ],
                                  ),
                                )
                              ],
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
      this.employeeRate,
      this.employerRate,
      this.finishTime
      );
  final String projectId;
  final String projectName;
  final String description;
  final List<String> skills;
  final double employeeRate;
  final double employerRate;
  final String finishTime;
}

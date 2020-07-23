import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'range_slider_view.dart';
import 'package:intl/intl.dart';
import 'hotel_app_theme.dart';
import 'FilterStaticDataType.dart';
import 'calendar_popup_view.dart';
import 'SkillChooseModal.dart';
import 'LiteSwitch.dart';


//TODO 两种技能搜索模式未区别实现，目前全部以模糊对待
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key key, this.filterConditionChange,})
      : super(key: key);

  final Function(FilterCondition) filterConditionChange;
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<PopularFilterListData> projectTypeListData =
      PopularFilterListData.projectTypeList;

  PriceRangeData _fixedPrices = PriceRangeData.filterRangeData[0];
  PriceRangeData _hourlyPrices = PriceRangeData.filterRangeData[1];

  bool _ifLimitDeadLine = false;
  DeadlineData _startDate = DeadlineData.deadlineData[0];
  DeadlineData _endDate = DeadlineData.deadlineData[1];

  bool _ifLimitSkills = false;
  final ValueNotifier<bool> switchState = new ValueNotifier<bool>(true);
  bool _chooseVagueModel = true;
  RequireSkills _skills = RequireSkills.skills;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    getTimeDateUI(),
                    Divider(
                      color: Colors.grey.withOpacity(0.6),
                      height: 1.0,
                      thickness: 1.0,
                      indent: 15.0,
                      endIndent: 15.0,
                    ),
                    projectTypeFilter(),
                    Divider(
                      color: Colors.grey.withOpacity(0.6),
                      height: 1.0,
                      thickness: 1.0,
                      indent: 15.0,
                      endIndent: 15.0,
                    ),
                    getSkillChooseUI(),
                    Divider(
                      color: Colors.grey.withOpacity(0.6),
                      height: 1.0,
                      thickness: 1.0,
                      indent: 15.0,
                      endIndent: 15.0,
                    ),
                    fixedPriceBarFilter(),
                    Divider(
                      color: Colors.grey.withOpacity(0.6),
                      height: 1.0,
                      thickness: 1.0,
                      indent: 15.0,
                      endIndent: 15.0,
                    ),
                    hourlyPriceBarFilter(),
                    Divider(
                      color: Colors.grey.withOpacity(0.6),
                      height: 1.0,
                      thickness: 1.0,
                      indent: 15.0,
                      endIndent: 15.0,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                      widget.filterConditionChange(FilterCondition(
                        fixedPriceExist: projectTypeListData[0],
                        hourlyPriceExist: projectTypeListData[1],
                        fixedPrices: _fixedPrices.prices,
                        hourlyPrices: _hourlyPrices.prices,
                        ifLimitDeadline: _ifLimitDeadLine,
                        startDate: _startDate.dateTime,
                        endDate: _endDate.dateTime,
                        ifLimitSkills: _ifLimitSkills,
                        requireSkills: _skills.requireSkills,
                      ));
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTimeDateUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Padding(
              padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              child: Text(
                '竞标截止日期',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 32, top: 16, bottom: 8),
                    child: Row(
                      children: [
                        Offstage(
                          offstage: _ifLimitDeadLine,
                          child: Text(
                            '无限制',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: !_ifLimitDeadLine,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
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
                                showDemoDialog(context: context);
                              },
                              child: Text(
                                '${DateFormat("dd, MMM").format(_startDate.dateTime)} - ${DateFormat("dd, MMM").format(_endDate.dateTime)}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Container(
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
                                  if(!_ifLimitDeadLine) showDemoDialog(context: context);
                                  setState(() {
                                    _ifLimitDeadLine = !_ifLimitDeadLine;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(_ifLimitDeadLine? Icons.close : Icons.build,
                                      size: 14,
                                      color: const Color(0xFFFFFFFF)),
                                ),
                              ),
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
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        initialEndDate: _endDate.dateTime,
        initialStartDate: _startDate.dateTime,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              _startDate.dateTime = startData;
              _endDate.dateTime = endData;
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  Widget projectTypeFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            '项目类型',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < projectTypeListData.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final PopularFilterListData date = projectTypeListData[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        date.isSelected = !date.isSelected;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            date.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: date.isSelected
                                ? HotelAppTheme.buildLightTheme().primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            date.titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          count += 1;
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget fixedPriceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '固定价格',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSliderView(
          values: _fixedPrices.prices,
          onChangeRangeValues: (RangeValues values) {
            setState(() {
              _fixedPrices.prices = values;
            });
          },
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget hourlyPriceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '小时价格',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSliderView2(
          values: _hourlyPrices.prices,
          onChangeRangeValues: (RangeValues values) {
            setState(() {
              _hourlyPrices.prices = values;
            });
          },
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget getSkillChooseUI() {
    List<Widget> skillManageList = _skills.requireSkills.map((skill) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Text(skill,
          style: TextStyle(height: 1)
      ),
    )).toList();
    skillManageList.add(Container(
      child: SizedOverflowBox(
        size: Size(32, 32),
        alignment: Alignment.center,
        child: IconButton(
          // action button
          icon: new Icon(Icons.add_circle, color: HexColor('#54D3C2'),),
          padding: const EdgeInsets.all(0),
          onPressed: () {
            _showSimpleDialog();
          },
        ),
      ),
    ));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Row(
            children: [
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    '相关技能',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Tooltip(
                  message: _chooseVagueModel? "项目技能要求至少包含所选技能之一" : "项目技能要求必须包含所选全部技能",
                  child: LiteSwitch(
                    switchState: switchState,
                    initValue: false,
                    textSize: 14.0,
                    iWidth: 100,
                    iHeight: 30,
                    textOn: '精准模式',
                    textOff: '模糊模式',
                    colorOn: HexColor('#54D3C2'),
                    colorOff: HexColor('#54D3C2'),
                    iconOn: IconData(0xe63e, fontFamily: 'MyIcons'),
                    iconOff: IconData(0xe669, fontFamily: 'MyIcons'),
                    onChanged: (bool state) {
                      setState(() {
                        _chooseVagueModel = !_chooseVagueModel;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 24, left: 21, bottom: 4, top: 4),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: skillManageList,
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  _showSimpleDialog() {
    onSkillChange(var skills) {
      if(skills.length == 0) _ifLimitSkills = false;
      else _ifLimitSkills = true;
      setState(() {
        _skills.requireSkills = skills;
      });
      Navigator.pop(context);
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SimpleDialog(title: Text('编辑相关技能'),
        // 这里传入一个选择器列表即可
        children: [
          SkillDialog(
            skillChoose: this._skills.requireSkills,
            onSkillChanged: onSkillChange,
          ),
        ]
      )
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}

class FilterCondition {
  FilterCondition({
    this.fixedPriceExist,
    this.hourlyPriceExist,
    this.fixedPrices,
    this.hourlyPrices,
    this.ifLimitDeadline,
    this.startDate,
    this.endDate,
    this.ifLimitSkills,
    this.requireSkills
  });
  PopularFilterListData fixedPriceExist;
  PopularFilterListData hourlyPriceExist;
  RangeValues fixedPrices;
  RangeValues hourlyPrices;
  bool ifLimitDeadline;
  DateTime startDate;
  DateTime endDate;
  bool ifLimitSkills;
  List<String> requireSkills;
}

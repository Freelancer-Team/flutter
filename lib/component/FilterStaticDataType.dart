import 'package:flutter/material.dart';

class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> projectTypeList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: '固定价格项目',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: '时薪项目',
      isSelected: true,
    ),
  ];
}

class PriceRangeData {
  PriceRangeData({
    this.prices,
  });

  RangeValues prices;

  /*数组下标为0的是fixedPrices，下标为1的是hourlyPrices*/
  static List<PriceRangeData> filterRangeData = [
    PriceRangeData(prices: RangeValues(1, 10000)),
    PriceRangeData(prices: RangeValues(1, 120)),
  ];
}

class DeadlineData {
  DeadlineData({
    this.dateTime
  });

  DateTime dateTime;

  static List<DeadlineData> deadlineData = [
    DeadlineData(dateTime: DateTime.now()),
    DeadlineData(dateTime: DateTime.now().add(const Duration(days: 7))),
  ];
}

class RequireSkills {
  RequireSkills({
    this.requireSkills
  });

  List<String> requireSkills;

  static RequireSkills skills = RequireSkills(requireSkills: []);
}

class IfLimit {
  IfLimit({
    this.ifLimit
  });

  bool ifLimit;

  static IfLimit ifLimitDeadline = IfLimit(ifLimit: false);
  static IfLimit ifLimitSkills = IfLimit(ifLimit: false);
  static IfLimit chooseVagueModel = IfLimit(ifLimit: true);
}

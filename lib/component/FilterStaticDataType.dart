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

  static List<PopularFilterListData> accommodationList = [
    PopularFilterListData(
      titleTxt: 'All',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Apartment',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Home',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Villa',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Hotel',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Resort',
      isSelected: false,
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

import 'package:flutter/material.dart';

class Criteria {
  final String symbol;
  final String criteria;
  final String attribute;
  final double weightValue;

  bool get isBenefit => attribute.toLowerCase() == "benefit";

  Criteria(
      {required this.symbol,
      required this.criteria,
      required this.attribute,
      required this.weightValue});
}

class MainMenu {
  final String title;
  final String desc;
  final String subDesc;
  final String offTitle;
  final String onTitle;
  final Widget pageNavigator;

  MainMenu({
    required this.title,
    required this.desc,
    required this.subDesc,
    required this.offTitle,
    required this.onTitle,
    required this.pageNavigator,
  });
}

class Alternative {
  final String name;
  double finalSumValue;

  Alternative(this.name, this.finalSumValue);
}

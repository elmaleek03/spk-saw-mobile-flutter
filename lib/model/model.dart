import 'package:flutter/material.dart';

class Criteria {
  final String symbol;
  final String criteria;
  final double weightValue;

  Criteria(
      {required this.symbol,
      required this.criteria,
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

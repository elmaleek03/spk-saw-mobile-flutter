import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
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

  factory Criteria.fromJson(Map<String, dynamic> json) => _$CriteriaFromJson(json);
  Map<String, dynamic> toJson() => _$CriteriaToJson(this);
}

@JsonSerializable()
class Alternative {
  final String name;
  double finalSumValue;

  Alternative(this.name, this.finalSumValue);

  factory Alternative.fromJson(Map<String, dynamic> json) => _$AlternativeFromJson(json);
  Map<String, dynamic> toJson() => _$AlternativeToJson(this);
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

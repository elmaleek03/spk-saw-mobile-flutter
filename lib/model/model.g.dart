// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Criteria _$CriteriaFromJson(Map<String, dynamic> json) => Criteria(
      symbol: json['symbol'] as String,
      criteria: json['criteria'] as String,
      attribute: json['attribute'] as String,
      weightValue: (json['weightValue'] as num).toDouble(),
    );

Map<String, dynamic> _$CriteriaToJson(Criteria instance) => <String, dynamic>{
      'symbol': instance.symbol,
      'criteria': instance.criteria,
      'attribute': instance.attribute,
      'weightValue': instance.weightValue,
    };

Alternative _$AlternativeFromJson(Map<String, dynamic> json) => Alternative(
      json['name'] as String,
      (json['finalSumValue'] as num).toDouble(),
    );

Map<String, dynamic> _$AlternativeToJson(Alternative instance) =>
    <String, dynamic>{
      'name': instance.name,
      'finalSumValue': instance.finalSumValue,
    };

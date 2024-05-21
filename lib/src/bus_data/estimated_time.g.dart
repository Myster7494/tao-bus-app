// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimated_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EstimatedTimeJson _$EstimatedTimeJsonFromJson(Map<String, dynamic> json) =>
    EstimatedTimeJson(
      plateNumb: json['PlateNumb'] as String,
      stopUid: json['StopUID'] as String,
      routeUid: json['RouteUID'] as String,
      direction: (json['Direction'] as num).toInt(),
      estimateTime: (json['EstimateTime'] as num?)?.toInt(),
      stopSequence: (json['StopSequence'] as num).toInt(),
      stopStatus: (json['StopStatus'] as num).toInt(),
      nextBusTime: json['NextBusTime'] == null
          ? null
          : DateTime.parse(json['NextBusTime'] as String),
      srcUpdateTime: DateTime.parse(json['SrcUpdateTime'] as String),
      updateTime: DateTime.parse(json['UpdateTime'] as String),
    );

Map<String, dynamic> _$EstimatedTimeJsonToJson(EstimatedTimeJson instance) =>
    <String, dynamic>{
      'PlateNumb': instance.plateNumb,
      'StopUID': instance.stopUid,
      'RouteUID': instance.routeUid,
      'Direction': instance.direction,
      'EstimateTime': instance.estimateTime,
      'StopSequence': instance.stopSequence,
      'StopStatus': instance.stopStatus,
      'NextBusTime': instance.nextBusTime?.toIso8601String(),
      'SrcUpdateTime': instance.srcUpdateTime.toIso8601String(),
      'UpdateTime': instance.updateTime.toIso8601String(),
    };

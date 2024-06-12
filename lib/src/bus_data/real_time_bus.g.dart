// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_time_bus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealTimeBus _$RealTimeBusFromJson(Map<String, dynamic> json) => RealTimeBus(
      plateNumb: json['PlateNumb'] as String,
      operatorNo: $enumDecode(_$OperatorNoEnumMap, json['OperatorNo']),
      routeUid: json['RouteUID'] as String,
      direction: (json['Direction'] as num).toInt(),
      busPosition:
          GeoPointJson.fromJson(json['BusPosition'] as Map<String, dynamic>),
      speed: (json['Speed'] as num).toInt(),
      azimuth: (json['Azimuth'] as num).toInt(),
      dutyStatus: (json['DutyStatus'] as num).toInt(),
      gpsTime: DateTime.parse(json['GPSTime'] as String),
      srcUpdateTime: DateTime.parse(json['SrcUpdateTime'] as String),
      updateTime: DateTime.parse(json['UpdateTime'] as String),
      busStatus: (json['BusStatus'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RealTimeBusToJson(RealTimeBus instance) =>
    <String, dynamic>{
      'PlateNumb': instance.plateNumb,
      'OperatorNo': _$OperatorNoEnumMap[instance.operatorNo]!,
      'RouteUID': instance.routeUid,
      'Direction': instance.direction,
      'BusPosition': instance.busPosition,
      'Speed': instance.speed,
      'Azimuth': instance.azimuth,
      'DutyStatus': instance.dutyStatus,
      'GPSTime': instance.gpsTime.toIso8601String(),
      'SrcUpdateTime': instance.srcUpdateTime.toIso8601String(),
      'UpdateTime': instance.updateTime.toIso8601String(),
      'BusStatus': instance.busStatus,
    };

const _$OperatorNoEnumMap = {
  OperatorNo.CHUNGLI_BUS: '0404',
  OperatorNo.HSINCHU_BUS: '1303',
  OperatorNo.JASUN_BUS: '1103',
  OperatorNo.JINGYANG_BUS: '0915',
  OperatorNo.JINTAI_BUS: '0806',
  OperatorNo.SANCHUNG_BUS: '0301',
  OperatorNo.TAOYUAN_BUS: '1002',
  OperatorNo.UNITED_HIGHWAY_BUS: '1201',
  OperatorNo.YACHENG_BUS: '0704',
  OperatorNo.YATUNG_BUS: '0702',
  OperatorNo.ZHINAN_BUS: '0907',
};

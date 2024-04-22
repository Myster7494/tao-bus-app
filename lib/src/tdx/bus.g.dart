// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
      plateNumb: json['PlateNumb'] as String,
      operatorId: $enumDecode(_$OperatorIdEnumMap, json['OperatorID']),
      operatorNo: $enumDecode(_$OperatorNoEnumMap, json['OperatorNo']),
      routeUid: json['RouteUID'] as String,
      routeId: json['RouteID'] as String,
      routeName: Name.fromJson(json['RouteName'] as Map<String, dynamic>),
      subRouteUid: json['SubRouteUID'] as String,
      subRouteId: json['SubRouteID'] as String,
      subRouteName: Name.fromJson(json['SubRouteName'] as Map<String, dynamic>),
      direction: json['Direction'] as int,
      busPosition:
          BusPosition.fromJson(json['BusPosition'] as Map<String, dynamic>),
      speed: json['Speed'] as int,
      azimuth: json['Azimuth'] as int,
      dutyStatus: json['DutyStatus'] as int,
      busStatus: json['BusStatus'] as int,
      gpsTime: DateTime.parse(json['GPSTime'] as String),
      srcUpdateTime: DateTime.parse(json['SrcUpdateTime'] as String),
      updateTime: DateTime.parse(json['UpdateTime'] as String),
    );

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
      'PlateNumb': instance.plateNumb,
      'OperatorID': _$OperatorIdEnumMap[instance.operatorId]!,
      'OperatorNo': _$OperatorNoEnumMap[instance.operatorNo]!,
      'RouteUID': instance.routeUid,
      'RouteID': instance.routeId,
      'RouteName': instance.routeName,
      'SubRouteUID': instance.subRouteUid,
      'SubRouteID': instance.subRouteId,
      'SubRouteName': instance.subRouteName,
      'Direction': instance.direction,
      'BusPosition': instance.busPosition,
      'Speed': instance.speed,
      'Azimuth': instance.azimuth,
      'DutyStatus': instance.dutyStatus,
      'BusStatus': instance.busStatus,
      'GPSTime': instance.gpsTime.toIso8601String(),
      'SrcUpdateTime': instance.srcUpdateTime.toIso8601String(),
      'UpdateTime': instance.updateTime.toIso8601String(),
    };

const _$OperatorIdEnumMap = {
  OperatorId.CHUNGLI_BUS: '2',
  OperatorId.HSINCHU_BUS: '5',
  OperatorId.JASUN_BUS: '10',
  OperatorId.JINGYANG_BUS: '24',
  OperatorId.JINTAI_BUS: '8',
  OperatorId.SANCHUNG_BUS: '9',
  OperatorId.TAOYUAN_BUS: '1',
  OperatorId.UNITED_HIGHWAY_BUS: '4',
  OperatorId.YACHENG_BUS: '925',
  OperatorId.YATUNG_BUS: '6',
  OperatorId.ZHINAN_BUS: '3',
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

BusPosition _$BusPositionFromJson(Map<String, dynamic> json) => BusPosition(
      positionLon: (json['PositionLon'] as num?)?.toDouble(),
      positionLat: (json['PositionLat'] as num?)?.toDouble(),
      geoHash: json['GeoHash'] as String?,
    );

Map<String, dynamic> _$BusPositionToJson(BusPosition instance) =>
    <String, dynamic>{
      'PositionLon': instance.positionLon,
      'PositionLat': instance.positionLat,
      'GeoHash': instance.geoHash,
    };

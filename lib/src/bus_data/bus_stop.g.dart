// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusStop _$BusStopFromJson(Map<String, dynamic> json) => BusStop(
      stopUid: json['StopUID'] as String,
      stopPosition:
          GeoPointJson.fromJson(json['StopPosition'] as Map<String, dynamic>),
      stationUid: json['StationUID'] as String,
      stopName: Name.fromJson(json['StopName'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusStopToJson(BusStop instance) => <String, dynamic>{
      'StopUID': instance.stopUid,
      'StopPosition': instance.stopPosition,
      'StationUID': instance.stationUid,
      'StopName': instance.stopName,
    };

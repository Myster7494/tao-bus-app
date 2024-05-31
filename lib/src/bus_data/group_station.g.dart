// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupStation _$GroupStationFromJson(Map<String, dynamic> json) => GroupStation(
      groupStationUid: json['GroupStationUID'] as String,
      groupStationName:
          Name.fromJson(json['GroupStationName'] as Map<String, dynamic>),
      groupStationPosition: Position.fromJson(
          json['GroupStationPosition'] as Map<String, dynamic>),
      stations:
          (json['Stations'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GroupStationToJson(GroupStation instance) =>
    <String, dynamic>{
      'GroupStationUID': instance.groupStationUid,
      'GroupStationName': instance.groupStationName,
      'GroupStationPosition': instance.groupStationPosition,
      'Stations': instance.stations,
    };

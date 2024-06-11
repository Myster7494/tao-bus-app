// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusStation _$BusStationFromJson(Map<String, dynamic> json) => BusStation(
      stationUid: json['StationUID'] as String,
      stationName: Name.fromJson(json['StationName'] as Map<String, dynamic>),
      stationPosition: GeoPointJson.fromJson(
          json['StationPosition'] as Map<String, dynamic>),
      stops: (json['Stops'] as List<dynamic>).map((e) => e as String).toList(),
      groupStationUid: json['GroupStationUID'] as String,
      bearing: $enumDecode(_$BearingEnumMap, json['Bearing']),
    );

Map<String, dynamic> _$BusStationToJson(BusStation instance) =>
    <String, dynamic>{
      'StationUID': instance.stationUid,
      'StationName': instance.stationName,
      'StationPosition': instance.stationPosition,
      'Stops': instance.stops,
      'GroupStationUID': instance.groupStationUid,
      'Bearing': _$BearingEnumMap[instance.bearing]!,
    };

const _$BearingEnumMap = {
  Bearing.E: 'E',
  Bearing.NE: 'NE',
  Bearing.N: 'N',
  Bearing.NW: 'NW',
  Bearing.W: 'W',
  Bearing.SW: 'SW',
  Bearing.S: 'S',
  Bearing.SE: 'SE',
};

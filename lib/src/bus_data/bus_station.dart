import 'package:json_annotation/json_annotation.dart';

import 'general_class.dart';

part 'bus_station.g.dart';

@JsonSerializable()
class BusStation {
  @JsonKey(name: "StationUID")
  final String stationUid;
  @JsonKey(name: "StationName")
  final Name stationName;
  @JsonKey(name: "StationPosition")
  final Position stationPosition;
  @JsonKey(name: "Stops")
  final List<String> stops;
  @JsonKey(name: "GroupStationUID")
  final String groupStationUid;

  const BusStation({
    required this.stationUid,
    required this.stationName,
    required this.stationPosition,
    required this.stops,
    required this.groupStationUid,
  });

  factory BusStation.fromJson(Map<String, dynamic> json) =>
      _$BusStationFromJson(json);

  Map<String, dynamic> toJson() => _$BusStationToJson(this);
}

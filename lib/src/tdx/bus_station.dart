import 'package:json_annotation/json_annotation.dart';

import 'general_class.dart';

part 'bus_station.g.dart';

@JsonSerializable()
class BusStation {
  @JsonKey(name: "StationName")
  final Name stationName;
  @JsonKey(name: "StationPosition")
  final Position stationPosition;
  @JsonKey(name: "Stops")
  final List<String> stops;

  BusStation({
    required this.stationName,
    required this.stationPosition,
    required this.stops,
  });

  factory BusStation.fromJson(Map<String, dynamic> json) =>
      _$BusStationFromJson(json);

  Map<String, dynamic> toJson() => _$BusStationToJson(this);
}

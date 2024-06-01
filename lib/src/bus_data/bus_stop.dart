import 'package:json_annotation/json_annotation.dart';

import 'general_class.dart';

part 'bus_stop.g.dart';

@JsonSerializable()
class BusStop {
  @JsonKey(name: "StopUID")
  final String stopUid;
  @JsonKey(name: "StopPosition")
  final GeoPointJson stopPosition;
  @JsonKey(name: "StationUID")
  final String stationUid;
  @JsonKey(name: "StopName")
  final Name stopName;

  const BusStop({
    required this.stopUid,
    required this.stopPosition,
    required this.stationUid,
    required this.stopName,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) =>
      _$BusStopFromJson(json);

  Map<String, dynamic> toJson() => _$BusStopToJson(this);
}

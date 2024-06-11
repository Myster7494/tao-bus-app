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
  final GeoPointJson stationPosition;
  @JsonKey(name: "Stops")
  final List<String> stops;
  @JsonKey(name: "GroupStationUID")
  final String groupStationUid;
  @JsonKey(name: "Bearing")
  final Bearing bearing;

  const BusStation({
    required this.stationUid,
    required this.stationName,
    required this.stationPosition,
    required this.stops,
    required this.groupStationUid,
    required this.bearing,
  });

  factory BusStation.fromJson(Map<String, dynamic> json) =>
      _$BusStationFromJson(json);

  Map<String, dynamic> toJson() => _$BusStationToJson(this);
}

enum Bearing {
  @JsonValue("E")
  E,
  @JsonValue("NE")
  NE,
  @JsonValue("N")
  N,
  @JsonValue("NW")
  NW,
  @JsonValue("W")
  W,
  @JsonValue("SW")
  SW,
  @JsonValue("S")
  S,
  @JsonValue("SE")
  SE;

  String toChinese() {
    switch (this) {
      case Bearing.E:
        return "東";
      case Bearing.NE:
        return "東北";
      case Bearing.N:
        return "北";
      case Bearing.NW:
        return "西北";
      case Bearing.W:
        return "西";
      case Bearing.SW:
        return "西南";
      case Bearing.S:
        return "南";
      case Bearing.SE:
        return "東南";
    }
  }
}

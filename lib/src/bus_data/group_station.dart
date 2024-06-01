import 'package:json_annotation/json_annotation.dart';

import 'general_class.dart';

part 'group_station.g.dart';

@JsonSerializable()
class GroupStation {
  @JsonKey(name: "GroupStationUID")
  final String groupStationUid;
  @JsonKey(name: "GroupStationName")
  final Name groupStationName;
  @JsonKey(name: "GroupStationPosition")
  final GeoPointJson groupStationPosition;
  @JsonKey(name: "Stations")
  final List<String> stations;

  const GroupStation({
    required this.groupStationUid,
    required this.groupStationName,
    required this.groupStationPosition,
    required this.stations,
  });

  factory GroupStation.fromJson(Map<String, dynamic> json) =>
      _$GroupStationFromJson(json);

  Map<String, dynamic> toJson() => _$GroupStationToJson(this);
}

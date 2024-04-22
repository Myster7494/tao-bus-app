import 'package:json_annotation/json_annotation.dart';

part 'general_class.g.dart';

@JsonSerializable()
class Name {
  @JsonKey(name: "Zh_tw")
  final String zhTw;
  @JsonKey(name: "En")
  final String? en;

  Name({
    required this.zhTw,
    this.en,
  });

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  Map<String, dynamic> toJson() => _$NameToJson(this);
}

@JsonSerializable()
class Position {
  @JsonKey(name: "PositionLon")
  final double positionLon;
  @JsonKey(name: "PositionLat")
  final double positionLat;
  @JsonKey(name: "GeoHash")
  final String geoHash;

  Position({
    required this.positionLon,
    required this.positionLat,
    required this.geoHash,
  });

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  Map<String, dynamic> toJson() => _$PositionToJson(this);
}

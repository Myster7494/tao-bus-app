import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:json_annotation/json_annotation.dart';

part 'general_class.g.dart';

@JsonSerializable()
class Name {
  @JsonKey(name: "Zh_tw")
  final String zhTw;
  @JsonKey(name: "En")
  final String? en;

  const Name({
    required this.zhTw,
    this.en,
  });

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  Map<String, dynamic> toJson() => _$NameToJson(this);
}

@JsonSerializable()
class GeoPointJson extends GeoPoint {
  @JsonKey(name: "PositionLon")
  final double positionLon;
  @JsonKey(name: "PositionLat")
  final double positionLat;

  GeoPointJson({
    required this.positionLon,
    required this.positionLat,
  }) : super(
          latitude: positionLat,
          longitude: positionLon,
        );

  factory GeoPointJson.fromJson(Map<String, dynamic> json) =>
      _$GeoPointJsonFromJson(json);

  Map<String, dynamic> toJson() => _$GeoPointJsonToJson(this);
}

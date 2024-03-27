import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bus.g.dart';

@JsonSerializable()
class Bus {
  @JsonKey(name: "PlateNumb")
  final String? plateNumb;
  @JsonKey(name: "OperatorID")
  final OperatorId? operatorId;
  @JsonKey(name: "OperatorNo")
  final OperatorNo? operatorNo;
  @JsonKey(name: "RouteUID")
  final String? routeUid;
  @JsonKey(name: "RouteID")
  final String? routeId;
  @JsonKey(name: "RouteName")
  final RouteName? routeName;
  @JsonKey(name: "SubRouteUID")
  final String? subRouteUid;
  @JsonKey(name: "SubRouteID")
  final String? subRouteId;
  @JsonKey(name: "SubRouteName")
  final RouteName? subRouteName;
  @JsonKey(name: "Direction")
  final int? direction;
  @JsonKey(name: "BusPosition")
  final BusPosition? busPosition;
  @JsonKey(name: "Speed")
  final int? speed;
  @JsonKey(name: "Azimuth")
  final int? azimuth;
  @JsonKey(name: "DutyStatus")
  final int? dutyStatus;
  @JsonKey(name: "BusStatus")
  final int? busStatus;
  @JsonKey(name: "GPSTime")
  final DateTime? gpsTime;
  @JsonKey(name: "SrcUpdateTime")
  final DateTime? srcUpdateTime;
  @JsonKey(name: "UpdateTime")
  final DateTime? updateTime;

  Bus({
    this.plateNumb,
    this.operatorId,
    this.operatorNo,
    this.routeUid,
    this.routeId,
    this.routeName,
    this.subRouteUid,
    this.subRouteId,
    this.subRouteName,
    this.direction,
    this.busPosition,
    this.speed,
    this.azimuth,
    this.dutyStatus,
    this.busStatus,
    this.gpsTime,
    this.srcUpdateTime,
    this.updateTime,
  });

  factory Bus.fromJson(Map<String, dynamic> json) => _$BusFromJson(json);

  Map<String, dynamic> toJson() => _$BusToJson(this);
}

@JsonSerializable()
class BusPosition {
  @JsonKey(name: "PositionLon")
  final double? positionLon;
  @JsonKey(name: "PositionLat")
  final double? positionLat;
  @JsonKey(name: "GeoHash")
  final String? geoHash;

  BusPosition({
    this.positionLon,
    this.positionLat,
    this.geoHash,
  });

  factory BusPosition.fromJson(Map<String, dynamic> json) =>
      _$BusPositionFromJson(json);

  Map<String, dynamic> toJson() => _$BusPositionToJson(this);
}

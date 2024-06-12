// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'general_class.dart';

part 'bus.g.dart';

@JsonSerializable()
class Bus {
  @JsonKey(name: "PlateNumb")
  final String plateNumb;
  @JsonKey(name: "OperatorID")
  final OperatorId operatorId;
  @JsonKey(name: "OperatorNo")
  final OperatorNo operatorNo;
  @JsonKey(name: "RouteUID")
  final String routeUid;
  @JsonKey(name: "RouteID")
  final String routeId;
  @JsonKey(name: "RouteName")
  final Name routeName;
  @JsonKey(name: "SubRouteUID")
  final String subRouteUid;
  @JsonKey(name: "SubRouteID")
  final String subRouteId;
  @JsonKey(name: "SubRouteName")
  final Name subRouteName;
  @JsonKey(name: "Direction")
  final int direction;
  @JsonKey(name: "BusPosition")
  final BusPosition busPosition;
  @JsonKey(name: "Speed")
  final int speed;
  @JsonKey(name: "Azimuth")
  final int azimuth;
  @JsonKey(name: "DutyStatus")
  final int dutyStatus;
  @JsonKey(name: "BusStatus")
  final int busStatus;
  @JsonKey(name: "GPSTime")
  final DateTime gpsTime;
  @JsonKey(name: "SrcUpdateTime")
  final DateTime srcUpdateTime;
  @JsonKey(name: "UpdateTime")
  final DateTime updateTime;

  const Bus({
    required this.plateNumb,
    required this.operatorId,
    required this.operatorNo,
    required this.routeUid,
    required this.routeId,
    required this.routeName,
    required this.subRouteUid,
    required this.subRouteId,
    required this.subRouteName,
    required this.direction,
    required this.busPosition,
    required this.speed,
    required this.azimuth,
    required this.dutyStatus,
    required this.busStatus,
    required this.gpsTime,
    required this.srcUpdateTime,
    required this.updateTime,
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

  const BusPosition({
    this.positionLon,
    this.positionLat,
    this.geoHash,
  });

  factory BusPosition.fromJson(Map<String, dynamic> json) =>
      _$BusPositionFromJson(json);

  Map<String, dynamic> toJson() => _$BusPositionToJson(this);
}

enum OperatorId {
  /// 中壢客運
  @JsonValue("2")
  CHUNGLI_BUS,

  /// 新竹客運
  @JsonValue("5")
  HSINCHU_BUS,

  /// 捷順交通
  @JsonValue("10")
  JASUN_BUS,

  /// 勁揚通運
  @JsonValue("24")
  JINGYANG_BUS,

  /// 金台通運
  @JsonValue("8")
  JINTAI_BUS,

  /// 三重客運
  @JsonValue("9")
  SANCHUNG_BUS,

  /// 桃園客運
  @JsonValue("1")
  TAOYUAN_BUS,

  /// 統聯客運
  @JsonValue("4")
  UNITED_HIGHWAY_BUS,

  /// 亞盛通運
  @JsonValue("925")
  YACHENG_BUS,

  /// 亞通客運
  @JsonValue("6")
  YATUNG_BUS,

  /// 指南客運
  @JsonValue("3")
  ZHINAN_BUS
}

enum OperatorNo {
  /// 中壢客運
  @JsonValue("0404")
  CHUNGLI_BUS,

  /// 新竹客運
  @JsonValue("1303")
  HSINCHU_BUS,

  /// 捷順交通
  @JsonValue("1103")
  JASUN_BUS,

  /// 勁揚通運
  @JsonValue("0915")
  JINGYANG_BUS,

  /// 金台通運
  @JsonValue("0806")
  JINTAI_BUS,

  /// 三重客運
  @JsonValue("0301")
  SANCHUNG_BUS,

  /// 桃園客運
  @JsonValue("1002")
  TAOYUAN_BUS,

  /// 統聯客運
  @JsonValue("1201")
  UNITED_HIGHWAY_BUS,

  /// 亞盛通運
  @JsonValue("0704")
  YACHENG_BUS,

  /// 亞通客運
  @JsonValue("0702")
  YATUNG_BUS,

  /// 指南客運
  @JsonValue("0907")
  ZHINAN_BUS;

  String toChinese() {
    switch (this) {
      case OperatorNo.CHUNGLI_BUS:
        return "中壢客運";
      case OperatorNo.HSINCHU_BUS:
        return "新竹客運";
      case OperatorNo.JASUN_BUS:
        return "捷順交通";
      case OperatorNo.JINGYANG_BUS:
        return "勁揚通運";
      case OperatorNo.JINTAI_BUS:
        return "金台通運";
      case OperatorNo.SANCHUNG_BUS:
        return "三重客運";
      case OperatorNo.TAOYUAN_BUS:
        return "桃園客運";
      case OperatorNo.UNITED_HIGHWAY_BUS:
        return "統聯客運";
      case OperatorNo.YACHENG_BUS:
        return "亞盛通運";
      case OperatorNo.YATUNG_BUS:
        return "亞通客運";
      case OperatorNo.ZHINAN_BUS:
        return "指南客運";
    }
  }
}

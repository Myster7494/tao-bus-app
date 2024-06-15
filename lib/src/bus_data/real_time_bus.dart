import 'package:bus_app/src/bus_data/bus.dart';
import 'package:bus_app/src/bus_data/general_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'real_time_bus.g.dart';

@JsonSerializable()
class RealTimeBus {
  @JsonKey(name: "PlateNumb")
  final String plateNumb;
  @JsonKey(name: "OperatorNo")
  final OperatorNo operatorNo;
  @JsonKey(name: "RouteUID")
  final String routeUid;
  @JsonKey(name: "Direction")
  final int direction;
  @JsonKey(name: "BusPosition")
  final GeoPointJson busPosition;
  @JsonKey(name: "Speed")
  final int speed;
  @JsonKey(name: "Azimuth")
  final int azimuth;
  @JsonKey(name: "DutyStatus")
  final int dutyStatus;
  @JsonKey(name: "GPSTime")
  final DateTime gpsTime;
  @JsonKey(name: "SrcUpdateTime")
  final DateTime srcUpdateTime;
  @JsonKey(name: "UpdateTime")
  final DateTime updateTime;
  @JsonKey(name: "BusStatus")
  final int? busStatus;

  RealTimeBus({
    required this.plateNumb,
    required this.operatorNo,
    required this.routeUid,
    required this.direction,
    required this.busPosition,
    required this.speed,
    required this.azimuth,
    required this.dutyStatus,
    required this.gpsTime,
    required this.srcUpdateTime,
    required this.updateTime,
    this.busStatus,
  });

  factory RealTimeBus.fromJson(Map<String, dynamic> json) =>
      _$RealTimeBusFromJson(json);

  Map<String, dynamic> toJson() => _$RealTimeBusToJson(this);
}

class AllRealTimeBus {
  final List<RealTimeBus> data;

  DateTime get lastUpdateTime => data.first.updateTime;

  AllRealTimeBus({required this.data});
}

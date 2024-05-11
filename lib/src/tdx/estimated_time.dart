import 'package:json_annotation/json_annotation.dart';

part 'estimated_time.g.dart';

@JsonSerializable()
class EstimatedTimeJson {
  @JsonKey(name: "PlateNumb")
  final String plateNumb;
  @JsonKey(name: "StopUID")
  final String stopUid;
  @JsonKey(name: "RouteUID")
  final String routeUid;
  @JsonKey(name: "Direction")
  final int direction;
  @JsonKey(name: "EstimateTime")
  final int? estimateTime;
  @JsonKey(name: "StopSequence")
  final int stopSequence;
  @JsonKey(name: "StopStatus")
  final int stopStatus;
  @JsonKey(name: "NextBusTime")
  final DateTime? nextBusTime;
  @JsonKey(name: "SrcUpdateTime")
  final DateTime srcUpdateTime;
  @JsonKey(name: "UpdateTime")
  final DateTime updateTime;

  EstimatedTimeJson({
    required this.plateNumb,
    required this.stopUid,
    required this.routeUid,
    required this.direction,
    this.estimateTime,
    required this.stopSequence,
    required this.stopStatus,
    this.nextBusTime,
    required this.srcUpdateTime,
    required this.updateTime,
  });

  factory EstimatedTimeJson.fromJson(Map<String, dynamic> json) =>
      _$EstimatedTimeJsonFromJson(json);

  Map<String, dynamic> toJson() => _$EstimatedTimeJsonToJson(this);
}

class EstimatedTimeData {
  final String plateNumb;
  final int? estimatedTime;
  final int stopSequence;
  final int stopStatus;
  final DateTime? nextBusTime;
  final DateTime srcUpdateTime;
  final DateTime updateTime;
  final bool isClosestStop;

  EstimatedTimeData({
    required this.plateNumb,
    this.estimatedTime,
    required this.isClosestStop,
    required this.stopSequence,
    required this.stopStatus,
    this.nextBusTime,
    required this.srcUpdateTime,
    required this.updateTime,
  });
}

class EstimatedTime {
  final Map<String, Map<int, Map<String, EstimatedTimeData>>> data;

  EstimatedTime({required this.data});

  factory EstimatedTime.fromJsonList(List<EstimatedTimeJson> json) {
    final data = <String, Map<int, Map<String, EstimatedTimeData>>>{};
    String plateNumb = "";
    for (final item in json) {
      bool isClosestStop = false;
      if (!data.containsKey(item.routeUid)) {
        data[item.routeUid] = {};
      }
      if (!data[item.routeUid]!.containsKey(item.direction)) {
        data[item.routeUid]![item.direction] = {};
      }
      if (item.plateNumb != plateNumb && item.plateNumb != "") {
        plateNumb = item.plateNumb;
        isClosestStop = true;
      }
      data[item.routeUid]![item.direction]![item.stopUid] = EstimatedTimeData(
        plateNumb: item.plateNumb,
        estimatedTime: item.estimateTime,
        isClosestStop: isClosestStop,
        stopSequence: item.stopSequence,
        stopStatus: item.stopStatus,
        nextBusTime: item.nextBusTime,
        srcUpdateTime: item.srcUpdateTime,
        updateTime: item.updateTime,
      );
    }
    return EstimatedTime(data: data);
  }
}

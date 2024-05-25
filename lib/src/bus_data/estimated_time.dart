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

  const EstimatedTimeJson({
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

  const EstimatedTimeData({
    required this.plateNumb,
    this.estimatedTime,
    required this.isClosestStop,
    required this.stopSequence,
    required this.stopStatus,
    this.nextBusTime,
    required this.srcUpdateTime,
    required this.updateTime,
  });

  factory EstimatedTimeData.noData() {
    return EstimatedTimeData(
      plateNumb: "",
      isClosestStop: false,
      stopSequence: -1,
      stopStatus: 999,
      srcUpdateTime: DateTime.now(),
      updateTime: DateTime.now(),
    );
  }
}

class OtherEstimatedData {
  final EstimatedTimeData estimatedTimeData;
  final List<int> closestStops;
  final String srcUpdateTime;

  const OtherEstimatedData({
    required this.estimatedTimeData,
    required this.closestStops,
    required this.srcUpdateTime,
  });
}

class AllEstimatedTime {
  final Map<String, Map<int, Map<String, EstimatedTimeData>>> data;

  AllEstimatedTime({required this.data});

  factory AllEstimatedTime.fromJsonList(List<EstimatedTimeJson> json) {
    final data = <String, Map<int, Map<String, EstimatedTimeData>>>{};
    String? lastRouteUid;
    int? lastDirection;
    String? lastPlateNumb;
    for (final item in json) {
      if (item.routeUid != lastRouteUid || item.direction != lastDirection) {
        lastRouteUid = item.routeUid;
        lastDirection = item.direction;
        lastPlateNumb = null;
      }
      bool isClosestStop = false;
      if (!data.containsKey(item.routeUid)) {
        data[item.routeUid] = {};
      }
      if (!data[item.routeUid]!.containsKey(item.direction)) {
        data[item.routeUid]![item.direction] = {};
      }
      if (item.plateNumb != lastPlateNumb) {
        lastPlateNumb = item.plateNumb;
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
    return AllEstimatedTime(data: data);
  }

  EstimatedTimeData? getEstimatedTimeData(String routeUid, int direction,
      {String? stopUid, int? stopSequence}) {
    if (stopUid == null) {
      if (stopSequence == null) {
        return null;
      }
      return data[routeUid]?[direction]
          ?.values
          .firstWhere((element) => element.stopSequence == stopSequence);
    }
    return data[routeUid]?[direction]?[stopUid];
  }
}

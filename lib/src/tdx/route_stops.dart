import 'package:json_annotation/json_annotation.dart';

part 'route_stops.g.dart';

@JsonSerializable()
class RouteStops {
  @JsonKey(name: "RouteUID")
  final String routeUid;
  @JsonKey(name: "Direction")
  final int direction;
  @JsonKey(name: "Stops")
  final List<RouteStop> stops;

  RouteStops({
    required this.routeUid,
    required this.direction,
    required this.stops,
  });

  factory RouteStops.fromJson(Map<String, dynamic> json) =>
      _$RouteStopsFromJson(json);

  Map<String, dynamic> toJson() => _$RouteStopsToJson(this);
}

@JsonSerializable()
class RouteStop {
  @JsonKey(name: "StopUID")
  final String stopUid;
  @JsonKey(name: "StopSequence")
  final int stopSequence;

  RouteStop({
    required this.stopUid,
    required this.stopSequence,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) =>
      _$RouteStopFromJson(json);

  Map<String, dynamic> toJson() => _$RouteStopToJson(this);
}

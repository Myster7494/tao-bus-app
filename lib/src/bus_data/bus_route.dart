import 'package:bus_app/src/bus_data/bus.dart';
import 'package:json_annotation/json_annotation.dart';

import '../widgets/web_image/web_image_data.dart';
import 'general_class.dart';

part 'bus_route.g.dart';

@JsonSerializable()
class BusRoute {
  @JsonKey(name: "RouteUID")
  final String routeUid;
  @JsonKey(name: "Operators")
  final List<OperatorNo> operators;
  @JsonKey(name: "SubRoutes")
  final List<SubRoute> subRoutes;
  @JsonKey(name: "RouteName")
  final Name routeName;
  @JsonKey(name: "DepartureStopNameZh")
  final String departureStopNameZh;
  @JsonKey(name: "DepartureStopNameEn")
  final String departureStopNameEn;
  @JsonKey(name: "DestinationStopNameZh")
  final String destinationStopNameZh;
  @JsonKey(name: "DestinationStopNameEn")
  final String destinationStopNameEn;
  @JsonKey(name: "Headsign")
  final String headsign;
  @JsonKey(name: "RouteMapImageData")
  final WebImageData routeMapImageData;

  const BusRoute({
    required this.routeUid,
    required this.operators,
    required this.subRoutes,
    required this.routeName,
    required this.departureStopNameZh,
    required this.departureStopNameEn,
    required this.destinationStopNameZh,
    required this.destinationStopNameEn,
    required this.headsign,
    required this.routeMapImageData,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) =>
      _$BusRouteFromJson(json);

  Map<String, dynamic> toJson() => _$BusRouteToJson(this);
}

@JsonSerializable()
class SubRoute {
  @JsonKey(name: "RouteUID")
  final String routeUid;
  @JsonKey(name: "Direction")
  final int direction;
  @JsonKey(name: "Points")
  final List<GeoPointJson> points;

  const SubRoute({
    required this.routeUid,
    required this.direction,
    required this.points,
  });

  factory SubRoute.fromJson(Map<String, dynamic> json) =>
      _$SubRouteFromJson(json);

  Map<String, dynamic> toJson() => _$SubRouteToJson(this);
}

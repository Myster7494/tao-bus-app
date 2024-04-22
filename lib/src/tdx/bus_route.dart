import 'package:json_annotation/json_annotation.dart';

import 'general_class.dart';

part 'bus_route.g.dart';

@JsonSerializable()
class BusRoute {
  @JsonKey(name: "RouteUID")
  final String routeUid;
  @JsonKey(name: "Operators")
  final List<String> operators;
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
  @JsonKey(name: "RouteMapImage")
  final RouteMapImage routeMapImage;

  BusRoute({
    required this.routeUid,
    required this.operators,
    required this.subRoutes,
    required this.routeName,
    required this.departureStopNameZh,
    required this.departureStopNameEn,
    required this.destinationStopNameZh,
    required this.destinationStopNameEn,
    required this.headsign,
    required this.routeMapImage,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) =>
      _$BusRouteFromJson(json);

  Map<String, dynamic> toJson() => _$BusRouteToJson(this);
}

@JsonSerializable()
class RouteMapImage {
  @JsonKey(name: "Url")
  final String url;
  @JsonKey(name: "Width")
  final int width;
  @JsonKey(name: "Height")
  final int height;

  RouteMapImage({
    required this.url,
    required this.width,
    required this.height,
  });

  factory RouteMapImage.fromJson(Map<String, dynamic> json) =>
      _$RouteMapImageFromJson(json);

  Map<String, dynamic> toJson() => _$RouteMapImageToJson(this);
}

@JsonSerializable()
class SubRoute {
  @JsonKey(name: "Direction")
  final int direction;

  SubRoute({
    required this.direction,
  });

  factory SubRoute.fromJson(Map<String, dynamic> json) =>
      _$SubRouteFromJson(json);

  Map<String, dynamic> toJson() => _$SubRouteToJson(this);
}

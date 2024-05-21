// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusRoute _$BusRouteFromJson(Map<String, dynamic> json) => BusRoute(
      routeUid: json['RouteUID'] as String,
      operators:
          (json['Operators'] as List<dynamic>).map((e) => e as String).toList(),
      subRoutes: (json['SubRoutes'] as List<dynamic>)
          .map((e) => SubRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
      routeName: Name.fromJson(json['RouteName'] as Map<String, dynamic>),
      departureStopNameZh: json['DepartureStopNameZh'] as String,
      departureStopNameEn: json['DepartureStopNameEn'] as String,
      destinationStopNameZh: json['DestinationStopNameZh'] as String,
      destinationStopNameEn: json['DestinationStopNameEn'] as String,
      headsign: json['Headsign'] as String,
      routeMapImageData: WebImageData.fromJson(
          json['RouteMapImageData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusRouteToJson(BusRoute instance) => <String, dynamic>{
      'RouteUID': instance.routeUid,
      'Operators': instance.operators,
      'SubRoutes': instance.subRoutes,
      'RouteName': instance.routeName,
      'DepartureStopNameZh': instance.departureStopNameZh,
      'DepartureStopNameEn': instance.departureStopNameEn,
      'DestinationStopNameZh': instance.destinationStopNameZh,
      'DestinationStopNameEn': instance.destinationStopNameEn,
      'Headsign': instance.headsign,
      'RouteMapImageData': instance.routeMapImageData,
    };

SubRoute _$SubRouteFromJson(Map<String, dynamic> json) => SubRoute(
      direction: (json['Direction'] as num).toInt(),
    );

Map<String, dynamic> _$SubRouteToJson(SubRoute instance) => <String, dynamic>{
      'Direction': instance.direction,
    };

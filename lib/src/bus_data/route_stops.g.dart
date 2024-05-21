// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_stops.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteStops _$RouteStopsFromJson(Map<String, dynamic> json) => RouteStops(
      routeUid: json['RouteUID'] as String,
      direction: (json['Direction'] as num).toInt(),
      stops: (json['Stops'] as List<dynamic>)
          .map((e) => RouteStop.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RouteStopsToJson(RouteStops instance) =>
    <String, dynamic>{
      'RouteUID': instance.routeUid,
      'Direction': instance.direction,
      'Stops': instance.stops,
    };

RouteStop _$RouteStopFromJson(Map<String, dynamic> json) => RouteStop(
      stopUid: json['StopUID'] as String,
      stopSequence: (json['StopSequence'] as num).toInt(),
    );

Map<String, dynamic> _$RouteStopToJson(RouteStop instance) => <String, dynamic>{
      'StopUID': instance.stopUid,
      'StopSequence': instance.stopSequence,
    };

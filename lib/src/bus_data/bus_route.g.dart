// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusRoute _$BusRouteFromJson(Map<String, dynamic> json) => BusRoute(
      routeUid: json['RouteUID'] as String,
      operators: (json['Operators'] as List<dynamic>)
          .map((e) => $enumDecode(_$OperatorNoEnumMap, e))
          .toList(),
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
      'Operators':
          instance.operators.map((e) => _$OperatorNoEnumMap[e]!).toList(),
      'SubRoutes': instance.subRoutes,
      'RouteName': instance.routeName,
      'DepartureStopNameZh': instance.departureStopNameZh,
      'DepartureStopNameEn': instance.departureStopNameEn,
      'DestinationStopNameZh': instance.destinationStopNameZh,
      'DestinationStopNameEn': instance.destinationStopNameEn,
      'Headsign': instance.headsign,
      'RouteMapImageData': instance.routeMapImageData,
    };

const _$OperatorNoEnumMap = {
  OperatorNo.CHUNGLI_BUS: '0404',
  OperatorNo.HSINCHU_BUS: '1303',
  OperatorNo.JASUN_BUS: '1103',
  OperatorNo.JINGYANG_BUS: '0915',
  OperatorNo.JINTAI_BUS: '0806',
  OperatorNo.SANCHUNG_BUS: '0301',
  OperatorNo.TAOYUAN_BUS: '1002',
  OperatorNo.UNITED_HIGHWAY_BUS: '1201',
  OperatorNo.YACHENG_BUS: '0704',
  OperatorNo.YATUNG_BUS: '0702',
  OperatorNo.ZHINAN_BUS: '0907',
};

SubRoute _$SubRouteFromJson(Map<String, dynamic> json) => SubRoute(
      routeUid: json['RouteUID'] as String,
      direction: (json['Direction'] as num).toInt(),
      points: (json['Points'] as List<dynamic>)
          .map((e) => GeoPointJson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubRouteToJson(SubRoute instance) => <String, dynamic>{
      'RouteUID': instance.routeUid,
      'Direction': instance.direction,
      'Points': instance.points,
    };

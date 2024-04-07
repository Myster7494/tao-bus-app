// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusRoute _$BusRouteFromJson(Map<String, dynamic> json) => BusRoute(
      routeUid: json['RouteUID'] as String,
      routeId: json['RouteID'] as String,
      hasSubRoutes: json['HasSubRoutes'] as bool,
      operators: (json['Operators'] as List<dynamic>)
          .map((e) => Operator.fromJson(e as Map<String, dynamic>))
          .toList(),
      authorityId: json['AuthorityID'] as String,
      providerId: json['ProviderID'] as String,
      subRoutes: (json['SubRoutes'] as List<dynamic>)
          .map((e) => SubRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
      busRouteType: json['BusRouteType'] as int,
      routeName: RouteName.fromJson(json['RouteName'] as Map<String, dynamic>),
      departureStopNameZh: json['DepartureStopNameZh'] as String,
      departureStopNameEn: json['DepartureStopNameEn'] as String,
      destinationStopNameZh: json['DestinationStopNameZh'] as String,
      destinationStopNameEn: json['DestinationStopNameEn'] as String,
      routeMapImage:
          RouteMapImage.fromJson(json['RouteMapImage'] as Map<String, dynamic>),
      city: $enumDecode(_$CityEnumMap, json['City']),
      cityCode: $enumDecode(_$CityCodeEnumMap, json['CityCode']),
      updateTime: DateTime.parse(json['UpdateTime'] as String),
      versionId: json['VersionID'] as int,
    );

Map<String, dynamic> _$BusRouteToJson(BusRoute instance) => <String, dynamic>{
      'RouteUID': instance.routeUid,
      'RouteID': instance.routeId,
      'HasSubRoutes': instance.hasSubRoutes,
      'Operators': instance.operators,
      'AuthorityID': instance.authorityId,
      'ProviderID': instance.providerId,
      'SubRoutes': instance.subRoutes,
      'BusRouteType': instance.busRouteType,
      'RouteName': instance.routeName,
      'DepartureStopNameZh': instance.departureStopNameZh,
      'DepartureStopNameEn': instance.departureStopNameEn,
      'DestinationStopNameZh': instance.destinationStopNameZh,
      'DestinationStopNameEn': instance.destinationStopNameEn,
      'RouteMapImage': instance.routeMapImage,
      'City': _$CityEnumMap[instance.city]!,
      'CityCode': _$CityCodeEnumMap[instance.cityCode]!,
      'UpdateTime': instance.updateTime.toIso8601String(),
      'VersionID': instance.versionId,
    };

const _$CityEnumMap = {
  City.TAOYUAN: 'Taoyuan',
};

const _$CityCodeEnumMap = {
  CityCode.TAO: 'TAO',
};

Operator _$OperatorFromJson(Map<String, dynamic> json) => Operator(
      operatorId: $enumDecode(_$OperatorIdEnumMap, json['OperatorID']),
      operatorName:
          OperatorName.fromJson(json['OperatorName'] as Map<String, dynamic>),
      operatorCode: $enumDecode(_$OperatorCodeEnumMap, json['OperatorCode']),
      operatorNo: $enumDecode(_$OperatorNoEnumMap, json['OperatorNo']),
    );

Map<String, dynamic> _$OperatorToJson(Operator instance) => <String, dynamic>{
      'OperatorID': _$OperatorIdEnumMap[instance.operatorId]!,
      'OperatorName': instance.operatorName,
      'OperatorCode': _$OperatorCodeEnumMap[instance.operatorCode]!,
      'OperatorNo': _$OperatorNoEnumMap[instance.operatorNo]!,
    };

const _$OperatorIdEnumMap = {
  OperatorId.CHUNGLI_BUS: '2',
  OperatorId.HSINCHU_BUS: '5',
  OperatorId.JASUN_BUS: '10',
  OperatorId.JINGYANG_BUS: '24',
  OperatorId.JINTAI_BUS: '8',
  OperatorId.SANCHUNG_BUS: '9',
  OperatorId.TAOYUAN_BUS: '1',
  OperatorId.UNITED_HIGHWAY_BUS: '4',
  OperatorId.YACHENG_BUS: '925',
  OperatorId.YATUNG_BUS: '6',
  OperatorId.ZHINAN_BUS: '3',
};

const _$OperatorCodeEnumMap = {
  OperatorCode.EMPTY: '',
  OperatorCode.CHUNGLI_BUS: 'ChungliBus',
  OperatorCode.HSINCHU_BUS: 'HsinchuBus',
  OperatorCode.JASUN_BUS: 'JasunBus',
  OperatorCode.JINTAI_BUS: 'JintaiTransport',
  OperatorCode.SANCHUNG_BUS: 'SanChungBus',
  OperatorCode.TAOYUAN_BUS: 'TaoyuanBus',
  OperatorCode.UNITED_HIGHWAY_BUS: 'UnitedHighwayBus',
  OperatorCode.YATUNG_BUS: 'YatungBus',
  OperatorCode.ZHINAN_BUS: 'ZhinanBus',
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

OperatorName _$OperatorNameFromJson(Map<String, dynamic> json) => OperatorName(
      zhTw: $enumDecode(_$ZhTwEnumMap, json['Zh_tw']),
      en: $enumDecodeNullable(_$EnEnumMap, json['En']),
    );

Map<String, dynamic> _$OperatorNameToJson(OperatorName instance) =>
    <String, dynamic>{
      'Zh_tw': _$ZhTwEnumMap[instance.zhTw]!,
      'En': _$EnEnumMap[instance.en],
    };

const _$ZhTwEnumMap = {
  ZhTw.CHUNGLI_BUS: '中壢客運',
  ZhTw.HSINCHU_BUS: '新竹客運',
  ZhTw.JASUN_BUS: '捷順交通',
  ZhTw.JINGYANG_BUS: '勁揚通運',
  ZhTw.JINTAI_BUS: '金台通運',
  ZhTw.SANCHUNG_BUS: '三重客運',
  ZhTw.TAOYUAN_BUS: '桃園客運',
  ZhTw.UNITED_HIGHWAY_BUS: '統聯客運',
  ZhTw.YACHENG_BUS: '亞盛通運',
  ZhTw.YATUNG_BUS: '亞通客運',
  ZhTw.ZHINAN_BUS: '指南客運',
};

const _$EnEnumMap = {
  En.CHUNGLI_BUS: 'Chungli Bus Co., Ltd.',
  En.HSINCHU_BUS: 'Hsinchu Bus Co., Ltd.',
  En.JINTAI_BUS: 'Jintai Transport Co., Ltd.',
  En.SANCHUNG_BUS: 'San Chung Bus Co., Ltd.',
  En.TAOYUAN_BUS: 'Taoyuan Bus Co., Ltd.',
  En.UNITED_HIGHWAY_BUS: 'United Highway Bus Co., Ltd.',
  En.YATUNG_BUS: 'Yatung Bus Co., Ltd.',
};

RouteName _$RouteNameFromJson(Map<String, dynamic> json) => RouteName(
      zhTw: json['Zh_tw'] as String,
      en: json['En'] as String,
    );

Map<String, dynamic> _$RouteNameToJson(RouteName instance) => <String, dynamic>{
      'Zh_tw': instance.zhTw,
      'En': instance.en,
    };

SubRoute _$SubRouteFromJson(Map<String, dynamic> json) => SubRoute(
      subRouteUid: json['SubRouteUID'] as String,
      subRouteId: json['SubRouteID'] as String,
      operatorIDs: (json['OperatorIDs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      subRouteName:
          RouteName.fromJson(json['SubRouteName'] as Map<String, dynamic>),
      headsign: json['Headsign'] as String,
      direction: json['Direction'] as int,
      stops: (json['Stops'] as List<dynamic>)
          .map((e) => Stop.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubRouteToJson(SubRoute instance) => <String, dynamic>{
      'SubRouteUID': instance.subRouteUid,
      'SubRouteID': instance.subRouteId,
      'OperatorIDs': instance.operatorIDs,
      'SubRouteName': instance.subRouteName,
      'Headsign': instance.headsign,
      'Direction': instance.direction,
      'Stops': instance.stops,
    };

RouteMapImage _$RouteMapImageFromJson(Map<String, dynamic> json) =>
    RouteMapImage(
      url: json['Url'] as String,
      width: json['Width'] as int,
      height: json['Height'] as int,
    );

Map<String, dynamic> _$RouteMapImageToJson(RouteMapImage instance) =>
    <String, dynamic>{
      'Url': instance.url,
      'Width': instance.width,
      'Height': instance.height,
    };

Stop _$StopFromJson(Map<String, dynamic> json) => Stop(
      stopUid: json['StopUID'] as String?,
      stopId: json['StopID'] as String?,
      stopName: json['StopName'] == null
          ? null
          : StopName.fromJson(json['StopName'] as Map<String, dynamic>),
      stopBoarding: json['StopBoarding'] as int?,
      stopSequence: json['StopSequence'] as int?,
      stopPosition: json['StopPosition'] == null
          ? null
          : StopPosition.fromJson(json['StopPosition'] as Map<String, dynamic>),
      stationId: json['StationID'] as String?,
      locationCityCode: json['LocationCityCode'] as String?,
    );

Map<String, dynamic> _$StopToJson(Stop instance) => <String, dynamic>{
      'StopUID': instance.stopUid,
      'StopID': instance.stopId,
      'StopName': instance.stopName,
      'StopBoarding': instance.stopBoarding,
      'StopSequence': instance.stopSequence,
      'StopPosition': instance.stopPosition,
      'StationID': instance.stationId,
      'LocationCityCode': instance.locationCityCode,
    };

StopName _$StopNameFromJson(Map<String, dynamic> json) => StopName(
      zhTw: json['Zh_tw'] as String?,
      en: json['En'] as String?,
    );

Map<String, dynamic> _$StopNameToJson(StopName instance) => <String, dynamic>{
      'Zh_tw': instance.zhTw,
      'En': instance.en,
    };

StopPosition _$StopPositionFromJson(Map<String, dynamic> json) => StopPosition(
      positionLon: (json['PositionLon'] as num?)?.toDouble(),
      positionLat: (json['PositionLat'] as num?)?.toDouble(),
      geoHash: json['GeoHash'] as String?,
    );

Map<String, dynamic> _$StopPositionToJson(StopPosition instance) =>
    <String, dynamic>{
      'PositionLon': instance.positionLon,
      'PositionLat': instance.positionLat,
      'GeoHash': instance.geoHash,
    };

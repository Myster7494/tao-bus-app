import 'package:json_annotation/json_annotation.dart';

part 'bus_route.g.dart';

@JsonSerializable()
class BusRoute {
  @JsonKey(name: "RouteUID")
  final String routeUid;
  @JsonKey(name: "RouteID")
  final String routeId;
  @JsonKey(name: "HasSubRoutes")
  final bool hasSubRoutes;
  @JsonKey(name: "Operators")
  final List<Operator> operators;
  @JsonKey(name: "AuthorityID")
  final String authorityId;
  @JsonKey(name: "ProviderID")
  final String providerId;
  @JsonKey(name: "SubRoutes")
  final List<SubRoute> subRoutes;
  @JsonKey(name: "BusRouteType")
  final int busRouteType;
  @JsonKey(name: "RouteName")
  final RouteName routeName;
  @JsonKey(name: "DepartureStopNameZh")
  final String departureStopNameZh;
  @JsonKey(name: "DepartureStopNameEn")
  final String departureStopNameEn;
  @JsonKey(name: "DestinationStopNameZh")
  final String destinationStopNameZh;
  @JsonKey(name: "DestinationStopNameEn")
  final String destinationStopNameEn;
  @JsonKey(name: "RouteMapImage")
  final RouteMapImage routeMapImage;
  @JsonKey(name: "City")
  final City city;
  @JsonKey(name: "CityCode")
  final CityCode cityCode;
  @JsonKey(name: "UpdateTime")
  final DateTime updateTime;
  @JsonKey(name: "VersionID")
  final int versionId;

  BusRoute({
    required this.routeUid,
    required this.routeId,
    required this.hasSubRoutes,
    required this.operators,
    required this.authorityId,
    required this.providerId,
    required this.subRoutes,
    required this.busRouteType,
    required this.routeName,
    required this.departureStopNameZh,
    required this.departureStopNameEn,
    required this.destinationStopNameZh,
    required this.destinationStopNameEn,
    required this.routeMapImage,
    required this.city,
    required this.cityCode,
    required this.updateTime,
    required this.versionId,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) =>
      _$BusRouteFromJson(json);

  Map<String, dynamic> toJson() => _$BusRouteToJson(this);
}

enum City {
  /// 桃園
  @JsonValue("Taoyuan")
  TAOYUAN
}

final cityValues = EnumValues({"Taoyuan": City.TAOYUAN});

enum CityCode {
  /// 桃園
  @JsonValue("TAO")
  TAO
}

final cityCodeValues = EnumValues({"TAO": CityCode.TAO});

@JsonSerializable()
class Operator {
  @JsonKey(name: "OperatorID")
  final OperatorId operatorId;
  @JsonKey(name: "OperatorName")
  final OperatorName operatorName;
  @JsonKey(name: "OperatorCode")
  final OperatorCode operatorCode;
  @JsonKey(name: "OperatorNo")
  final OperatorNo operatorNo;

  Operator({
    required this.operatorId,
    required this.operatorName,
    required this.operatorCode,
    required this.operatorNo,
  });

  factory Operator.fromJson(Map<String, dynamic> json) =>
      _$OperatorFromJson(json);

  Map<String, dynamic> toJson() => _$OperatorToJson(this);
}

enum OperatorId {
  /// 中壢客運
  @JsonValue("2")
  CHUNGLI_BUS,

  /// 新竹客運
  @JsonValue("5")
  HSINCHU_BUS,

  /// 捷順交通
  @JsonValue("10")
  JASUN_BUS,

  /// 勁揚通運
  @JsonValue("24")
  JINGYANG_BUS,

  /// 金台通運
  @JsonValue("8")
  JINTAI_BUS,

  /// 三重客運
  @JsonValue("9")
  SANCHUNG_BUS,

  /// 桃園客運
  @JsonValue("1")
  TAOYUAN_BUS,

  /// 統聯客運
  @JsonValue("4")
  UNITED_HIGHWAY_BUS,

  /// 亞盛通運
  @JsonValue("925")
  YACHENG_BUS,

  /// 亞通客運
  @JsonValue("6")
  YATUNG_BUS,

  /// 指南客運
  @JsonValue("3")
  ZHINAN_BUS
}

enum OperatorCode {
  @JsonValue("")
  EMPTY,

  /// 中壢客運
  @JsonValue("ChungliBus")
  CHUNGLI_BUS,

  /// 新竹客運
  @JsonValue("HsinchuBus")
  HSINCHU_BUS,

  /// 捷順交通
  @JsonValue("JasunBus")
  JASUN_BUS,

  /// 金台通運
  @JsonValue("JintaiTransport")
  JINTAI_BUS,

  /// 三重客運
  @JsonValue("SanChungBus")
  SANCHUNG_BUS,

  /// 桃園客運
  @JsonValue("TaoyuanBus")
  TAOYUAN_BUS,

  /// 統聯客運
  @JsonValue("UnitedHighwayBus")
  UNITED_HIGHWAY_BUS,

  /// 亞通客運
  @JsonValue("YatungBus")
  YATUNG_BUS,

  /// 指南客運
  @JsonValue("ZhinanBus")
  ZHINAN_BUS
}

enum OperatorNo {
  /// 中壢客運
  @JsonValue("0404")
  CHUNGLI_BUS,

  /// 新竹客運
  @JsonValue("1303")
  HSINCHU_BUS,

  /// 捷順交通
  @JsonValue("1103")
  JASUN_BUS,

  /// 勁揚通運
  @JsonValue("0915")
  JINGYANG_BUS,

  /// 金台通運
  @JsonValue("0806")
  JINTAI_BUS,

  /// 三重客運
  @JsonValue("0301")
  SANCHUNG_BUS,

  /// 桃園客運
  @JsonValue("1002")
  TAOYUAN_BUS,

  /// 統聯客運
  @JsonValue("1201")
  UNITED_HIGHWAY_BUS,

  /// 亞盛通運
  @JsonValue("0704")
  YACHENG_BUS,

  /// 亞通客運
  @JsonValue("0702")
  YATUNG_BUS,

  /// 指南客運
  @JsonValue("0907")
  ZHINAN_BUS
}

final operatorCodeValues = EnumValues({
  "ChungliBus": OperatorCode.CHUNGLI_BUS,
  "": OperatorCode.EMPTY,
  "HsinchuBus": OperatorCode.HSINCHU_BUS,
  "JasunBus": OperatorCode.JASUN_BUS,
  "JintaiTransport": OperatorCode.JINTAI_BUS,
  "SanChungBus": OperatorCode.SANCHUNG_BUS,
  "TaoyuanBus": OperatorCode.TAOYUAN_BUS,
  "UnitedHighwayBus": OperatorCode.UNITED_HIGHWAY_BUS,
  "YatungBus": OperatorCode.YATUNG_BUS,
  "ZhinanBus": OperatorCode.ZHINAN_BUS
});

@JsonSerializable()
class OperatorName {
  @JsonKey(name: "Zh_tw")
  final ZhTw zhTw;
  @JsonKey(name: "En")
  final En? en;

  OperatorName({
    required this.zhTw,
    this.en,
  });

  factory OperatorName.fromJson(Map<String, dynamic> json) =>
      _$OperatorNameFromJson(json);

  Map<String, dynamic> toJson() => _$OperatorNameToJson(this);
}

enum En {
  /// 中壢客運
  @JsonValue("Chungli Bus Co., Ltd.")
  CHUNGLI_BUS,

  /// 新竹客運
  @JsonValue("Hsinchu Bus Co., Ltd.")
  HSINCHU_BUS,

  /// 金台通運
  @JsonValue("Jintai Transport Co., Ltd.")
  JINTAI_BUS,

  /// 三重客運
  @JsonValue("San Chung Bus Co., Ltd.")
  SANCHUNG_BUS,

  /// 桃園客運
  @JsonValue("Taoyuan Bus Co., Ltd.")
  TAOYUAN_BUS,

  /// 統聯客運
  @JsonValue("United Highway Bus Co., Ltd.")
  UNITED_HIGHWAY_BUS,

  /// 亞通客運
  @JsonValue("Yatung Bus Co., Ltd.")
  YATUNG_BUS
}

final enValues = EnumValues({
  "Chungli Bus Co., Ltd.": En.CHUNGLI_BUS,
  "Hsinchu Bus Co., Ltd.": En.HSINCHU_BUS,
  "Jintai Transport Co., Ltd.": En.JINTAI_BUS,
  "San Chung Bus Co., Ltd.": En.SANCHUNG_BUS,
  "Taoyuan Bus Co., Ltd.": En.TAOYUAN_BUS,
  "United Highway Bus Co., Ltd.": En.UNITED_HIGHWAY_BUS,
  "Yatung Bus Co., Ltd.": En.YATUNG_BUS
});

enum ZhTw {
  /// 中壢客運
  @JsonValue("中壢客運")
  CHUNGLI_BUS,

  /// 新竹客運
  @JsonValue("新竹客運")
  HSINCHU_BUS,

  /// 捷順交通
  @JsonValue("捷順交通")
  JASUN_BUS,

  /// 勁揚通運
  @JsonValue("勁揚通運")
  JINGYANG_BUS,

  /// 金台通運
  @JsonValue("金台通運")
  JINTAI_BUS,

  /// 三重客運
  @JsonValue("三重客運")
  SANCHUNG_BUS,

  /// 桃園客運
  @JsonValue("桃園客運")
  TAOYUAN_BUS,

  /// 統聯客運
  @JsonValue("統聯客運")
  UNITED_HIGHWAY_BUS,

  /// 亞盛通運
  @JsonValue("亞盛通運")
  YACHENG_BUS,

  /// 亞通客運
  @JsonValue("亞通客運")
  YATUNG_BUS,

  /// 指南客運
  @JsonValue("指南客運")
  ZHINAN_BUS,
}

final zhTwValues = EnumValues({
  "亞盛通運": ZhTw.YACHENG_BUS,
  "捷順交通": ZhTw.JASUN_BUS,
  "指南客運": ZhTw.ZHINAN_BUS,
  "統聯客運": ZhTw.UNITED_HIGHWAY_BUS,
  "新竹客運": ZhTw.CHUNGLI_BUS,
  "三重客運": ZhTw.SANCHUNG_BUS,
  "勁揚通運": ZhTw.JINGYANG_BUS,
  "桃園客運": ZhTw.TAOYUAN_BUS,
  "金台通運": ZhTw.JINTAI_BUS,
  "亞通客運": ZhTw.YATUNG_BUS,
  "中壢客運": ZhTw.CHUNGLI_BUS
});

@JsonSerializable()
class RouteName {
  @JsonKey(name: "Zh_tw")
  final String zhTw;
  @JsonKey(name: "En")
  final String en;

  RouteName({
    required this.zhTw,
    required this.en,
  });

  factory RouteName.fromJson(Map<String, dynamic> json) =>
      _$RouteNameFromJson(json);

  Map<String, dynamic> toJson() => _$RouteNameToJson(this);
}

@JsonSerializable()
class SubRoute {
  @JsonKey(name: "SubRouteUID")
  final String subRouteUid;
  @JsonKey(name: "SubRouteID")
  final String subRouteId;
  @JsonKey(name: "OperatorIDs")
  final List<String> operatorIDs;
  @JsonKey(name: "SubRouteName")
  final RouteName subRouteName;
  @JsonKey(name: "Headsign")
  final String headsign;
  @JsonKey(name: "Direction")
  final int direction;
  @JsonKey(name: "Stops")
  final List<Stop> stops;

  SubRoute({
    required this.subRouteUid,
    required this.subRouteId,
    required this.operatorIDs,
    required this.subRouteName,
    required this.headsign,
    required this.direction,
    required this.stops,
  });

  factory SubRoute.fromJson(Map<String, dynamic> json) =>
      _$SubRouteFromJson(json);

  Map<String, dynamic> toJson() => _$SubRouteToJson(this);
}

@JsonSerializable()
class RouteMapImage {
  @JsonKey(name: "Url")
  final String url;
  @JsonKey(name: "Width")
  final int width;
  @JsonKey(name: "Height")
  final int height;

  RouteMapImage({required this.url, required this.width, required this.height});

  factory RouteMapImage.fromJson(Map<String, dynamic> json) =>
      _$RouteMapImageFromJson(json);

  Map<String, dynamic> toJson() => _$RouteMapImageToJson(this);
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

@JsonSerializable()
class Stop {
  @JsonKey(name: "StopUID")
  final String? stopUid;
  @JsonKey(name: "StopID")
  final String? stopId;
  @JsonKey(name: "StopName")
  final StopName? stopName;
  @JsonKey(name: "StopBoarding")
  final int? stopBoarding;
  @JsonKey(name: "StopSequence")
  final int? stopSequence;
  @JsonKey(name: "StopPosition")
  final StopPosition? stopPosition;
  @JsonKey(name: "StationID")
  final String? stationId;
  @JsonKey(name: "LocationCityCode")
  final String? locationCityCode;

  Stop({
    this.stopUid,
    this.stopId,
    this.stopName,
    this.stopBoarding,
    this.stopSequence,
    this.stopPosition,
    this.stationId,
    this.locationCityCode,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);

  Map<String, dynamic> toJson() => _$StopToJson(this);
}

@JsonSerializable()
class StopName {
  @JsonKey(name: "Zh_tw")
  final String? zhTw;
  @JsonKey(name: "En")
  final String? en;

  StopName({
    this.zhTw,
    this.en,
  });

  factory StopName.fromJson(Map<String, dynamic> json) =>
      _$StopNameFromJson(json);

  Map<String, dynamic> toJson() => _$StopNameToJson(this);
}

@JsonSerializable()
class StopPosition {
  @JsonKey(name: "PositionLon")
  final double? positionLon;
  @JsonKey(name: "PositionLat")
  final double? positionLat;
  @JsonKey(name: "GeoHash")
  final String? geoHash;

  StopPosition({
    this.positionLon,
    this.positionLat,
    this.geoHash,
  });

  factory StopPosition.fromJson(Map<String, dynamic> json) =>
      _$StopPositionFromJson(json);

  Map<String, dynamic> toJson() => _$StopPositionToJson(this);
}

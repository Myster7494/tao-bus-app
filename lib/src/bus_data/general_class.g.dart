// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Name _$NameFromJson(Map<String, dynamic> json) => Name(
      zhTw: json['Zh_tw'] as String,
      en: json['En'] as String?,
    );

Map<String, dynamic> _$NameToJson(Name instance) => <String, dynamic>{
      'Zh_tw': instance.zhTw,
      'En': instance.en,
    };

GeoPointJson _$GeoPointJsonFromJson(Map<String, dynamic> json) => GeoPointJson(
      positionLon: (json['PositionLon'] as num).toDouble(),
      positionLat: (json['PositionLat'] as num).toDouble(),
    );

Map<String, dynamic> _$GeoPointJsonToJson(GeoPointJson instance) =>
    <String, dynamic>{
      'PositionLon': instance.positionLon,
      'PositionLat': instance.positionLat,
    };

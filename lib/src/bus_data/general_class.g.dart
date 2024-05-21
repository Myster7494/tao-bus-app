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

Position _$PositionFromJson(Map<String, dynamic> json) => Position(
      positionLon: (json['PositionLon'] as num).toDouble(),
      positionLat: (json['PositionLat'] as num).toDouble(),
      geoHash: json['GeoHash'] as String,
    );

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'PositionLon': instance.positionLon,
      'PositionLat': instance.positionLat,
      'GeoHash': instance.geoHash,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_image_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebImageData _$WebImageDataFromJson(Map<String, dynamic> json) => WebImageData(
      url: json['Url'] as String,
      width: (json['Width'] as num).toInt(),
      height: (json['Height'] as num).toInt(),
    );

Map<String, dynamic> _$WebImageDataToJson(WebImageData instance) =>
    <String, dynamic>{
      'Url': instance.url,
      'Width': instance.width,
      'Height': instance.height,
    };

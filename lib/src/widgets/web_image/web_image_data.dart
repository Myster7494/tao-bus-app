import 'package:json_annotation/json_annotation.dart';

part 'web_image_data.g.dart';

@JsonSerializable()
class WebImageData {
  @JsonKey(name: "Url")
  final String url;
  @JsonKey(name: "Width")
  final int width;
  @JsonKey(name: "Height")
  final int height;

  const WebImageData({
    required this.url,
    required this.width,
    required this.height,
  });

  factory WebImageData.fromJson(Map<String, dynamic> json) =>
      _$WebImageDataFromJson(json);

  Map<String, dynamic> toJson() => _$WebImageDataToJson(this);
}

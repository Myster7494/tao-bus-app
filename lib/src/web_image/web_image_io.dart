import 'package:bus_app/src/web_image/web_image_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WebImage extends StatelessWidget {
  final WebImageData webImageData;

  const WebImage({super.key, required this.webImageData});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.contain,
      imageUrl: webImageData.url,
    );
  }
}

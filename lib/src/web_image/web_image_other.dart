import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RouteMapWebImage extends StatelessWidget {
  final RouteMapImage routeMapImage;

  const RouteMapWebImage({super.key, required this.routeMapImage});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => const LinearProgressIndicator(),
      fit: BoxFit.contain,
      imageUrl: routeMapImage.url,
    );
  }
}

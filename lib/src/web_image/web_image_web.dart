import 'dart:html';
import 'dart:ui_web';

import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:flutter/cupertino.dart';

class RouteMapWebImage extends StatelessWidget {
  final RouteMapImage routeMapImage;

  const RouteMapWebImage({super.key, required this.routeMapImage});

  @override
  Widget build(BuildContext context) {
    platformViewRegistry.registerViewFactory(routeMapImage.url, (viewId) {
      ImageElement imageElement = ImageElement(
        src: routeMapImage.url,
      );
      imageElement.style.width = "100%";
      imageElement.style.height = "100%";
      return imageElement;
    });
    return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: routeMapImage.width as double,
          height: routeMapImage.height as double,
          child: HtmlElementView(viewType: routeMapImage.url),
        ));
  }
}

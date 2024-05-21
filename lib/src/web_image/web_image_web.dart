// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui_web';
import 'package:bus_app/src/web_image/web_image_data.dart';
import 'package:flutter/cupertino.dart';

class WebImage extends StatelessWidget {
  final WebImageData webImageData;

  const WebImage({super.key, required this.webImageData});

  @override
  Widget build(BuildContext context) {
    platformViewRegistry.registerViewFactory(webImageData.url, (viewId) {
      ImageElement imageElement = ImageElement(
        src: webImageData.url,
      );
      imageElement.draggable = false;
      imageElement.style.width = "100%";
      imageElement.style.height = "100%";
      return imageElement;
    });
    return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: webImageData.width as double,
          height: webImageData.height as double,
          child: HtmlElementView(viewType: webImageData.url),
        ));
  }
}

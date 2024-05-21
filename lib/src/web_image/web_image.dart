import 'package:bus_app/src/web_image/web_image_data.dart';
import 'package:flutter/cupertino.dart'
    if (dart.library.web) 'web_image_web.dart'
    if (dart.library.io) 'web_image_io.dart';

class WebImage extends StatelessWidget {
  const WebImage({super.key, required WebImageData webImageData});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

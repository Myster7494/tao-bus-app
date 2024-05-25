export 'web_image_base.dart'
    if (dart.library.html) 'web_image_web.dart'
    if (dart.library.io) 'web_image_io.dart';

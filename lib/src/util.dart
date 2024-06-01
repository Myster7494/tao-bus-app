import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

abstract class Util {
  static const rad = pi / 180;
  static const halfRad = pi / 360;

  static void showSnackBar(BuildContext context, String message,
      {Duration? duration, SnackBarAction? action}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      showCloseIcon: true,
      duration: duration ?? const Duration(seconds: 3),
      action: action,
    ));
  }

  static double twoGeoPointsDistance(GeoPoint p1, GeoPoint p2) {
    final phi1 = p1.latitude * rad;
    final phi2 = p2.latitude * rad;
    final deltaPhi = (p2.latitude - p1.latitude) * rad;
    final deltaLambda = (p2.longitude - p1.longitude) * rad;

    final double a =
        sqrtSin(deltaPhi / 2) + sqrtCos2(phi1, phi2) * sqrtSin(deltaLambda / 2);

    return 12742e3 * atan2(sqrt(a), sqrt(1 - a)); //metres
  }

  static GeoPoint positionToGeoPoint(Position position) {
    return GeoPoint(latitude: position.latitude, longitude: position.longitude);
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

abstract class Util {
  static const rad = pi / 180;
  static const halfRad = pi / 360;
  static bool? enableGps;

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

  static Future<bool> hasGps() async {
    if (enableGps != null) return enableGps!;

    enableGps = false;
    if (await requestGpsPermission() == false) return false;
    if (!kIsWeb) return (await Geolocator.getLastKnownPosition() != null);
    try {
      await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 5));
      enableGps = true;
      return true;
    } on TimeoutException {
      return false;
    }
  }

  static Future<bool> requestGpsPermission() async {
    enableGps = false;
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    enableGps = true;
    return true;
  }
}

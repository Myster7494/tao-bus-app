import 'dart:convert';

import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:flutter/services.dart';

class BusRoutesLoader {
  static late final List<BusRoute> busRoutes;

  static Future<void> loadBusRoutes() async {
    final jsonString = await rootBundle.loadString('assets/bus_routes.json');
    final List jsonObjects = jsonDecode(jsonString);
    busRoutes = jsonObjects
        .map((jsonObject) => BusRoute.fromJson(jsonObject))
        .toList()
        .cast<BusRoute>()
      ..sort(
        (a, b) => a.routeName.zhTw.compareTo(b.routeName.zhTw),
      );
  }
}

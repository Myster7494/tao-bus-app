import 'dart:convert';

import '../bus_data/route_stops.dart';
import 'storage.dart';

class LocalStorage {
  Future<void> init() async {
    await StorageHelper.init();
    if (StorageHelper.get('favorite_stops') == null) {
      StorageHelper.set('favorite_stops', {});
    }
  }

  set favoriteStops(Map<String, List<RouteStops>> stops) {
    StorageHelper.set('favorite_stops',
        stops.map((key, value) => MapEntry(key, jsonEncode(value))));
  }

  Map<String, List<RouteStops>> get favoriteStops =>
      StorageHelper.get<Map>('favorite_stops').map((key, value) {
        return MapEntry(
            key,
            jsonDecode(value)
                .map((e) => RouteStops.fromJson(e))
                .cast<RouteStops>()
                .toList());
      });
}

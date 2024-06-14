import 'dart:convert';
import 'dart:ui';

import '../bus_data/route_stops.dart';
import 'app_theme.dart';
import 'storage.dart';

class LocalStorage {
  Future<void> init() async {
    await StorageHelper.init();
    if (StorageHelper.get('favorite_stops') == null) {
      StorageHelper.set('favorite_stops', {});
    }
    if (StorageHelper.get('last_update') == null) {
      StorageHelper.set('last_update', {});
    }
  }

  set favoriteStops(Map<String, List<RouteStops>> stops) => StorageHelper.set(
      'favorite_stops',
      stops.map((key, value) => MapEntry(key, jsonEncode(value))));

  Map<String, List<RouteStops>> get favoriteStops =>
      StorageHelper.get<Map>('favorite_stops').map((key, value) => MapEntry(
          key,
          jsonDecode(value)
              .map((e) => RouteStops.fromJson(e))
              .cast<RouteStops>()
              .toList()));

  AppTheme get appTheme => AppTheme.values.byName(
      StorageHelper.get<String>('app_theme', AppTheme.followSystem.name));

  set appTheme(AppTheme value) => StorageHelper.set('app_theme', value.name);

  Color get accentColor =>
      Color(StorageHelper.get<int>('accent_color', 0xFFD0BCFF));

  set accentColor(Color? value) =>
      StorageHelper.set<int?>('accent_color', value?.value);
}

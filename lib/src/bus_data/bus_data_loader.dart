import 'dart:convert';

import 'package:flutter/services.dart';

import 'bus_route.dart';
import 'bus_station.dart';
import 'bus_stop.dart';
import 'estimated_time.dart';
import 'route_stops.dart';

abstract class BusDataLoader {
  static late final Map<String, BusRoute> busRoutes;
  static late final Map<String, BusStop> busStops;
  static late final Map<String, List<RouteStops>> routeStops;
  static late final Map<String, BusStation> busStations;
  static late final AllEstimatedTime allEstimatedTime;

  static Future<void> loadBusRoutes() async {
    final jsonString = await rootBundle.loadString('assets/bus_routes.json');
    final Map jsonObject = jsonDecode(jsonString);
    busRoutes =
        jsonObject.map((key, value) => MapEntry(key, BusRoute.fromJson(value)));
  }

  static Future<void> loadBusStops() async {
    final jsonString = await rootBundle.loadString('assets/bus_stops.json');
    final Map jsonObject = jsonDecode(jsonString);
    busStops =
        jsonObject.map((key, value) => MapEntry(key, BusStop.fromJson(value)));
  }

  static Future<void> loadRouteStops() async {
    final jsonString = await rootBundle.loadString('assets/route_stops.json');
    final Map jsonObject = jsonDecode(jsonString);
    routeStops = jsonObject.map((key, value) => MapEntry(
        key,
        (value as List)
            .map((jsonObject) => RouteStops.fromJson(jsonObject))
            .toList()));
  }

  static Future<void> loadBusStations() async {
    final jsonString = await rootBundle.loadString('assets/bus_stations.json');
    final Map jsonObject = jsonDecode(jsonString);
    busStations = jsonObject
        .map((key, value) => MapEntry(key, BusStation.fromJson(value)));
  }

  static Future<void> loadEstimatedTime() async {
    final jsonString =
        await rootBundle.loadString('assets/estimated_time.json');
    final List jsonObjects = jsonDecode(jsonString);
    allEstimatedTime = AllEstimatedTime.fromJsonList(jsonObjects
        .map((jsonObject) => EstimatedTimeJson.fromJson(jsonObject))
        .toList());
  }

  static Future<void> loadAllData() async {
    await loadBusRoutes();
    await loadBusStops();
    await loadRouteStops();
    await loadBusStations();
    await loadEstimatedTime();
  }

  static BusRoute? getBusRoute(String routeUid) {
    return busRoutes[routeUid];
  }

  static List<BusRoute> getAllBusRoutes() {
    return busRoutes.values.toList();
  }

  static BusStop? getBusStop(String stopUid) {
    return busStops[stopUid];
  }

  static List<RouteStop>? getRouteStopsByDirection(
      String routeUid, int direction) {
    return BusDataLoader.routeStops[routeUid]!
        .firstWhere((element) => element.direction == direction)
        .stops;
  }

  static RouteStop? getRouteStopByUid(
      String routeUid, int direction, String stopUid) {
    return getRouteStopsByDirection(routeUid, direction)
        ?.firstWhere((element) => element.stopUid == stopUid);
  }
}

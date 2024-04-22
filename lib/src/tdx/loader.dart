import 'dart:convert';

import 'package:bus_app/src/tdx/bus_station.dart';
import 'package:bus_app/src/tdx/bus_stop.dart';
import 'package:bus_app/src/tdx/estimated_time.dart';
import 'package:bus_app/src/tdx/route_stops.dart';

import 'bus_route.dart';
import 'package:flutter/services.dart';

abstract class Loader {
  static late final Map<String, BusRoute> busRoutes;
  static late final Map<String, BusStop> busStops;
  static late final Map<String, List<RouteStops>> routeStops;
  static late final Map<String, BusStation> busStations;

  static late final EstimatedTime estimatedTime;

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
    estimatedTime = EstimatedTime.fromJsonList(jsonObjects
        .map((jsonObject) => EstimatedTimeJson.fromJson(jsonObject))
        .toList());
  }

  static List<RouteStop> getStopsByDirection(String routeUid, int direction) {
    return routeStops[routeUid]!
        .where((element) => element.direction == direction)
        .first
        .stops;
  }
}

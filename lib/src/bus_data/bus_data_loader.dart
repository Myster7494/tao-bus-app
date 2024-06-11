import 'dart:convert';

import 'package:bus_app/src/bus_data/group_station.dart';
import 'package:flutter/services.dart';

import 'bus_route.dart';
import 'bus_station.dart';
import 'bus_stop.dart';
import 'estimated_time.dart';
import 'route_stops.dart';

typedef BusRoutesType = Map<String, BusRoute>;
typedef BusStopsType = Map<String, BusStop>;
typedef RouteStopsType = Map<String, List<RouteStops>>;
typedef BusStationsType = Map<String, BusStation>;
typedef GroupStationsType = Map<String, GroupStation>;

abstract class BusDataLoader {
  static late final BusRoutesType busRoutes;
  static late final BusStopsType busStops;
  static late final RouteStopsType routeStops;
  static late final BusStationsType busStations;
  static late final GroupStationsType groupStations;
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

  static Future<void> loadGroupStations() async {
    final jsonString =
        await rootBundle.loadString('assets/group_stations.json');
    final Map jsonObject = jsonDecode(jsonString);
    groupStations = jsonObject
        .map((key, value) => MapEntry(key, GroupStation.fromJson(value)));
  }

  static Future<void> loadAllData() async {
    await loadBusRoutes();
    await loadBusStops();
    await loadRouteStops();
    await loadBusStations();
    await loadGroupStations();
    await loadEstimatedTime();
  }

  static List<BusRoute> getAllBusRoutesList([BusRoutesType? busRoutesMap]) {
    busRoutesMap ??= getAllBusRoutesMap();
    return busRoutes.values.toList();
  }

  static BusRoutesType getAllBusRoutesMap([List<BusRoute>? busStationsList]) {
    if (busStationsList == null) return Map.of(BusDataLoader.busRoutes);
    return Map.fromEntries(busStationsList
        .map((busRoute) => MapEntry(busRoute.routeUid, busRoute)));
  }

  static List<BusStation> getAllBusStationsList(
      [BusStationsType? busStationsMap]) {
    busStationsMap ??= BusDataLoader.busStations;
    return busStations.values.toList();
  }

  static BusStationsType getAllBusStationsMap(
      [List<BusStation>? busStationsList]) {
    if (busStationsList == null) return Map.of(BusDataLoader.busStations);
    return Map.fromEntries(busStationsList
        .map((busStation) => MapEntry(busStation.stationUid, busStation)));
  }

  static List<BusStop> getAllBusStopsList([BusStopsType? busStopsMap]) {
    busStopsMap ??= BusDataLoader.busStops;
    return busStops.values.toList();
  }

  static BusStopsType getAllBusStopsMap([List<BusStop>? busStopsList]) {
    if (busStopsList == null) return Map.of(BusDataLoader.busStops);
    return Map.fromEntries(
        busStopsList.map((busStop) => MapEntry(busStop.stopUid, busStop)));
  }

  static List<GroupStation> getAllGroupStationsList(
      [GroupStationsType? groupStationsMap]) {
    groupStationsMap ??= BusDataLoader.groupStations;
    return groupStations.values.toList();
  }

  static GroupStationsType getAllGroupStationsMap(
      [List<GroupStation>? groupStationsList]) {
    if (groupStationsList == null) return Map.of(BusDataLoader.groupStations);
    return Map.fromEntries(groupStationsList.map((groupStation) =>
        MapEntry(groupStation.groupStationUid, groupStation)));
  }

  static List<RouteStops> getAllRouteStopsList(
      [RouteStopsType? routeStopsMap]) {
    routeStopsMap ??= BusDataLoader.routeStops;
    return routeStops.values.expand((element) => element).toList();
  }

  static RouteStopsType getAllRouteStopsMap(
      // [List<RouteStops>? routeStopsList]
      ) {
    return Map.of(BusDataLoader.routeStops);
  }
}

import 'dart:convert';

import 'package:bus_app/src/bus_data/group_station.dart';
import 'package:bus_app/src/bus_data/real_time_bus.dart';
import 'package:bus_app/src/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import 'bus_route.dart';
import 'bus_station.dart';
import 'bus_stop.dart';
import 'car_data.dart';
import 'estimated_time.dart';
import 'route_stops.dart';

abstract class BusDataLoader {
  static Future<void> loadBusRoutes() async {
    final jsonString = await rootBundle.loadString('assets/bus_routes.json');
    final Map jsonObject = jsonDecode(jsonString);
    RecordData.busRoutes =
        jsonObject.map((key, value) => MapEntry(key, BusRoute.fromJson(value)));
  }

  static Future<void> loadBusStops() async {
    final jsonString = await rootBundle.loadString('assets/bus_stops.json');
    final Map jsonObject = jsonDecode(jsonString);
    RecordData.busStops =
        jsonObject.map((key, value) => MapEntry(key, BusStop.fromJson(value)));
  }

  static Future<void> loadRouteStops() async {
    final jsonString = await rootBundle.loadString('assets/route_stops.json');
    final Map jsonObject = jsonDecode(jsonString);
    RecordData.routeStops = jsonObject.map((key, value) => MapEntry(
        key,
        (value as List)
            .map((jsonObject) => RouteStops.fromJson(jsonObject))
            .toList()));
  }

  static Future<void> loadBusStations() async {
    final jsonString = await rootBundle.loadString('assets/bus_stations.json');
    final Map jsonObject = jsonDecode(jsonString);
    RecordData.busStations = jsonObject
        .map((key, value) => MapEntry(key, BusStation.fromJson(value)));
  }

  static Future<void> loadGroupStations() async {
    final jsonString =
        await rootBundle.loadString('assets/group_stations.json');
    final Map jsonObject = jsonDecode(jsonString);
    RecordData.groupStations = jsonObject
        .map((key, value) => MapEntry(key, GroupStation.fromJson(value)));
  }

  static Future<void> loadEstimatedTime({String? jsonString}) async {
    try {
      final Response response = await dio.get(
        'https://raw.githubusercontent.com/Myster7494/tao-bus-app/data/data/estimated_time.json',
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        jsonString = utf8.decode(response.data);
      }
    } catch (e) {
      debugPrint('Cannot download estimated_time_data from Github: $e');
    }
    jsonString ??= await rootBundle.loadString('assets/estimated_time.json');
    final List jsonObjects = jsonDecode(jsonString);
    RecordData.allEstimatedTime = AllEstimatedTime.fromJsonList(jsonObjects
        .map((jsonObject) => EstimatedTimeJson.fromJson(jsonObject))
        .toList());
  }

  static Future<void> loadRealTimeBuses({String? jsonString}) async {
    try {
      final Response response = await dio.get(
        'https://raw.githubusercontent.com/Myster7494/tao-bus-app/data/data/real_time_bus.json',
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        jsonString = utf8.decode(response.data);
      }
    } catch (e) {
      debugPrint('Cannot download real_time_buses from Github: $e');
    }
    jsonString ??= await rootBundle.loadString('assets/real_time_bus.json');
    final List jsonObjects = jsonDecode(jsonString);
    RecordData.realTimeBuses = AllRealTimeBus(
        data: jsonObjects
            .map((jsonObject) => RealTimeBus.fromJson(jsonObject))
            .toList());
  }

  static Future<void> loadCarData() async {
    final jsonString = await rootBundle.loadString('assets/car_data.json');
    final Map jsonObject = jsonDecode(jsonString);
    RecordData.carData =
        jsonObject.map((key, value) => MapEntry(key, CarData.fromJson(value)));
  }

  static Future<void> loadAllData() async {
    await loadBusRoutes();
    await loadBusStops();
    await loadRouteStops();
    await loadBusStations();
    await loadGroupStations();
    await loadCarData();
    await loadEstimatedTime();
    await loadRealTimeBuses();
  }

  static List<BusRoute> getAllBusRoutesList([BusRoutesType? busRoutesMap]) {
    busRoutesMap ??= getAllBusRoutesMap();
    return busRoutesMap.values.toList();
  }

  static BusRoutesType getAllBusRoutesMap([List<BusRoute>? busStationsList]) {
    if (busStationsList == null) return Map.of(RecordData.busRoutes);
    return Map.fromEntries(busStationsList
        .map((busRoute) => MapEntry(busRoute.routeUid, busRoute)));
  }

  static List<BusStation> getAllBusStationsList(
      [BusStationsType? busStationsMap]) {
    busStationsMap ??= RecordData.busStations;
    return busStationsMap.values.toList();
  }

  static BusStationsType getAllBusStationsMap(
      [List<BusStation>? busStationsList]) {
    if (busStationsList == null) return Map.of(RecordData.busStations);
    return Map.fromEntries(busStationsList
        .map((busStation) => MapEntry(busStation.stationUid, busStation)));
  }

  static List<BusStop> getAllBusStopsList([BusStopsType? busStopsMap]) {
    busStopsMap ??= RecordData.busStops;
    return busStopsMap.values.toList();
  }

  static BusStopsType getAllBusStopsMap([List<BusStop>? busStopsList]) {
    if (busStopsList == null) return Map.of(RecordData.busStops);
    return Map.fromEntries(
        busStopsList.map((busStop) => MapEntry(busStop.stopUid, busStop)));
  }

  static List<GroupStation> getAllGroupStationsList(
      [GroupStationsType? groupStationsMap]) {
    groupStationsMap ??= RecordData.groupStations;
    return groupStationsMap.values.toList();
  }

  static GroupStationsType getAllGroupStationsMap(
      [List<GroupStation>? groupStationsList]) {
    if (groupStationsList == null) return Map.of(RecordData.groupStations);
    return Map.fromEntries(groupStationsList.map((groupStation) =>
        MapEntry(groupStation.groupStationUid, groupStation)));
  }

  static List<RouteStops> getAllRouteStopsList(
      [RouteStopsType? routeStopsMap]) {
    routeStopsMap ??= RecordData.routeStops;
    return routeStopsMap.values.expand((element) => element).toList();
  }

  static RouteStopsType getAllRouteStopsMap() {
    return Map.of(RecordData.routeStops);
  }

  static List<RealTimeBus> getDefaultAllRealTimeBusesList() {
    return List.of(RecordData.realTimeBuses.data);
  }
}

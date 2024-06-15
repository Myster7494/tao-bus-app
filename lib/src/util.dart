import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

import 'bus_data/bus_data_loader.dart';
import 'bus_data/bus_route.dart';
import 'bus_data/bus_station.dart';
import 'bus_data/bus_stop.dart';
import 'bus_data/car_data.dart';
import 'bus_data/estimated_time.dart';
import 'bus_data/group_station.dart';
import 'bus_data/real_time_bus.dart';
import 'bus_data/route_stops.dart';

typedef BusRoutesType = Map<String, BusRoute>;
typedef BusStopsType = Map<String, BusStop>;
typedef RouteStopsType = Map<String, List<RouteStops>>;
typedef BusStationsType = Map<String, BusStation>;
typedef GroupStationsType = Map<String, GroupStation>;
typedef CarDataType = Map<String, CarData>;

abstract class RecordData {
  static bool? enableGps;
  static late final BusRoutesType busRoutes;
  static late final BusStopsType busStops;
  static late final RouteStopsType routeStops;
  static late final BusStationsType busStations;
  static late final GroupStationsType groupStations;
  static late final CarDataType carData;
  static late AllEstimatedTime allEstimatedTime;
  static late AllRealTimeBus realTimeBuses;
}

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

  static Future<bool> hasGps() async {
    if (RecordData.enableGps != null) return RecordData.enableGps!;

    RecordData.enableGps = false;
    if (await requestGpsPermission() == false) return false;
    if (!kIsWeb) return (await Geolocator.getLastKnownPosition() != null);
    try {
      await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 5));
      RecordData.enableGps = true;
      return true;
    } on TimeoutException {
      return false;
    }
  }

  static Future<bool> requestGpsPermission() async {
    RecordData.enableGps = false;
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    RecordData.enableGps = true;
    return true;
  }

  static BusRoute? getBusRoute(String routeUid, [BusRoutesType? busRoutes]) {
    busRoutes ??= BusDataLoader.getAllBusRoutesMap();
    return busRoutes[routeUid];
  }

  static BusStation? getBusStation(String stationUid,
      [BusStationsType? busStations]) {
    busStations ??= BusDataLoader.getAllBusStationsMap();
    return busStations[stationUid];
  }

  static BusStop? getBusStop(String stopUid, [BusStopsType? busStops]) {
    busStops ??= BusDataLoader.getAllBusStopsMap();
    return busStops[stopUid];
  }

  static List<RouteStop>? getRouteStopsByDirection(
      String routeUid, int direction,
      [RouteStopsType? routeStops]) {
    routeStops ??= BusDataLoader.getAllRouteStopsMap();
    return routeStops[routeUid]!
        .firstWhere((element) => element.direction == direction)
        .stops;
  }

  static RouteStop? getRouteStopByUid(
      String routeUid, int direction, String stopUid) {
    return getRouteStopsByDirection(routeUid, direction)
        ?.firstWhere((element) => element.stopUid == stopUid);
  }

  static GroupStation? getGroupStation(String groupStationUid,
      [GroupStationsType? groupStations]) {
    groupStations ??= BusDataLoader.getAllGroupStationsMap();
    return groupStations[groupStationUid];
  }

  static CarData? getCarData(String plateNumb, [CarDataType? carData]) {
    carData ??= RecordData.carData;
    return carData[plateNumb];
  }

  static int sortRoutes(BusRoute a, BusRoute b) {
    if (a.routeName.zhTw.startsWith(RegExp(r'[^0-9]')) ||
        b.routeName.zhTw.startsWith(RegExp(r'[^0-9]'))) {
      return a.routeName.zhTw.compareTo(b.routeName.zhTw);
    }
    String aNum = a.routeName.zhTw.replaceAll(RegExp(r'[^0-9]'), '');
    String bNum = b.routeName.zhTw.replaceAll(RegExp(r'[^0-9]'), '');
    if (aNum == bNum) {
      return a.routeName.zhTw.compareTo(b.routeName.zhTw);
    }
    return aNum.compareTo(bNum);
  }
}

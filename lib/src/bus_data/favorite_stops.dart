import 'package:bus_app/src/bus_data/route_stops.dart';

import '../../main.dart';

abstract class FavoriteStops {
  static List<RouteStop>? getRouteFavoriteStops(
      String routeUid, int direction) {
    return (localStorage.favoriteStops[routeUid])
        ?.firstWhere((element) => element.direction == direction,
            orElse: () =>
                RouteStops(routeUid: routeUid, direction: direction, stops: []))
        .stops;
  }

  static void mergeFavoriteStop(
      String routeUid, int direction, List<RouteStop>? stops) {
    if (stops == null) {
      return;
    }
    Map<String, List<RouteStops>> favoriteStops = localStorage.favoriteStops;
    if (!favoriteStops.containsKey(routeUid)) {
      favoriteStops[routeUid] = [
        RouteStops(routeUid: routeUid, direction: direction, stops: stops)
      ];
    } else if (!favoriteStops[routeUid]!.any((e) => e.direction == direction)) {
      favoriteStops[routeUid]!.add(
          RouteStops(routeUid: routeUid, direction: direction, stops: stops));
    } else {
      if (stops.isEmpty) {
        favoriteStops[routeUid]!.removeWhere((e) => e.direction == direction);
        if (favoriteStops[routeUid]!.isEmpty) {
          favoriteStops.remove(routeUid);
        }
      } else {
        favoriteStops[routeUid]!
            .firstWhere((e) => e.direction == direction)
            .stops
          ..clear()
          ..addAll(stops);
      }
    }

    localStorage.favoriteStops = favoriteStops;
  }

  static void addFavoriteStop(String routeUid, int direction, RouteStop stop) {
    mergeFavoriteStop(routeUid, direction,
        (getRouteFavoriteStops(routeUid, direction) ?? [])..add(stop));
  }

  static void removeFavoriteStop(
          String routeUid, int direction, RouteStop stop) =>
      mergeFavoriteStop(
          routeUid,
          direction,
          getRouteFavoriteStops(routeUid, direction)
            ?..removeWhere((e) =>
                e.stopUid == stop.stopUid ||
                e.stopSequence == stop.stopSequence));

  static bool isFavoriteStop(String routeUid, int direction, RouteStop stop) =>
      getRouteFavoriteStops(routeUid, direction)?.any((e) =>
          e.stopUid == stop.stopUid || e.stopSequence == stop.stopSequence) ??
      false;
}

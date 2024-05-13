import '../tdx/route_stops.dart';
import 'assets_loader.dart';

abstract class Util {
  static List<RouteStop> getStopsByDirection(String routeUid, int direction) {
    return AssetsLoader.routeStops[routeUid]!
        .where((element) => element.direction == direction)
        .first
        .stops;
  }
}

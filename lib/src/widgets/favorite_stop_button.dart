import 'package:bus_app/src/bus_data/route_stops.dart';
import 'package:flutter/material.dart';

import '../bus_data/bus_data_loader.dart';
import '../bus_data/bus_stop.dart';
import '../bus_data/favorite_stops.dart';
import '../util.dart';

class FavoriteStopButton extends StatelessWidget {
  final String routeUid;
  final int direction;
  final String stopUid;
  final Function(VoidCallback function) setState;

  const FavoriteStopButton({
    super.key,
    required this.routeUid,
    required this.direction,
    required this.stopUid,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    RouteStop routeStop =
        BusDataLoader.getRouteStopByUid(routeUid, direction, stopUid)!;
    BusStop busStop = BusDataLoader.getBusStop(stopUid)!;
    return IconButton(
      tooltip: FavoriteStops.isFavoriteStop(routeUid, direction, routeStop)
          ? '移除收藏'
          : '加入收藏',
      icon: FavoriteStops.isFavoriteStop(
        routeUid,
        direction,
        routeStop,
      )
          ? const Icon(Icons.bookmark)
          : const Icon(Icons.bookmark_border),
      onPressed: () => setState(
        () {
          if (FavoriteStops.isFavoriteStop(routeUid, direction, routeStop)) {
            FavoriteStops.removeFavoriteStop(routeUid, direction, routeStop);
            Util.showSnackBar(
              context,
              '已將站牌「${busStop.stopName.zhTw}」移除收藏',
              action: SnackBarAction(
                label: '復原',
                onPressed: () => setState(
                  () => FavoriteStops.addFavoriteStop(
                      routeUid, direction, routeStop),
                ),
              ),
            );
          } else {
            FavoriteStops.addFavoriteStop(routeUid, direction, routeStop);
            Util.showSnackBar(
              context,
              '已將站牌「${busStop.stopName.zhTw}」加入收藏',
              action: SnackBarAction(
                label: '復原',
                onPressed: () => setState(
                  () => FavoriteStops.removeFavoriteStop(
                      routeUid, direction, routeStop),
                ),
              ),

            );
          }
        },
      ),
    );
  }
}

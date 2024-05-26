import 'package:bus_app/src/bus_data/bus_route.dart';
import 'package:bus_app/src/bus_data/route_stops.dart';
import 'package:bus_app/src/widgets/favorite_stop_button.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../bus_data/bus_data_loader.dart';
import '../widgets/estimated_time_text.dart';

class FavoriteStopsPage extends StatefulWidget {
  const FavoriteStopsPage({super.key});

  @override
  State<FavoriteStopsPage> createState() => _FavoriteStopsPageState();
}

class _FavoriteStopsPageState extends State<FavoriteStopsPage> {
  @override
  Widget build(BuildContext context) {
    if (localStorage.favoriteStops.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border,
                size: 100, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            const Text(
              '尚無任何收藏站牌',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      );
    }
    return ListView(
      children: [
        for (List<RouteStops> routeStopList
            in localStorage.favoriteStops.values)
          for (RouteStops routeStops in routeStopList)
            for (RouteStop stop in routeStops.stops)
              Builder(
                builder: (context) {
                  BusRoute busRoute =
                      BusDataLoader.getBusRoute(routeStops.routeUid)!;
                  return ListTile(
                    title: Text(
                      BusDataLoader.busStops[stop.stopUid]!.stopName.zhTw,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      '${busRoute.routeName.zhTw} | ${busRoute.headsign} | 往 ${routeStops.direction == 0 ? busRoute.destinationStopNameZh : busRoute.departureStopNameZh}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        EstimatedTimeText(
                          routeUid: routeStops.routeUid,
                          direction: routeStops.direction,
                          stopUid: stop.stopUid,
                          showPlateNumb: true,
                        ),
                        const SizedBox(width: 10),
                        FavoriteStopButton(
                            routeUid: routeStops.routeUid,
                            direction: routeStops.direction,
                            stopUid: stop.stopUid,
                            setState: setState),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }
}

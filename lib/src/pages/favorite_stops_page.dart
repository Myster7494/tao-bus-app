import 'package:bus_app/src/bus_data/bus_route.dart';
import 'package:bus_app/src/bus_data/route_stops.dart';
import 'package:bus_app/src/pages/station_detail_page.dart';
import 'package:bus_app/src/widgets/favorite_stop_button.dart';
import 'package:bus_app/src/widgets/theme_provider.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../util.dart';
import '../widgets/estimated_time_text.dart';
import 'bus_state_page.dart';

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
    return ThemeProvider(
      builder: (context, themeData) => ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            for (List<RouteStops> routeStopList
                in localStorage.favoriteStops.values)
              for (RouteStops routeStops in routeStopList)
                for (RouteStop routeStop in routeStops.stops)
                  Builder(
                    builder: (context) {
                      BusRoute busRoute =
                          Util.getBusRoute(routeStops.routeUid)!;
                      return ListTile(
                        title: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeData.colorScheme.secondaryContainer,
                              ),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(right: 5),
                              child: FittedBox(
                                child: Text(
                                  routeStop.stopSequence.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: themeData.colorScheme.onSurface),
                                ),
                              ),
                            ),
                            Text(
                              Util.getBusStop(routeStop.stopUid)!.stopName.zhTw,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
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
                              stopUid: routeStop.stopUid,
                              showPlateNumb: true,
                            ),
                            FavoriteStopButton(
                                routeUid: routeStops.routeUid,
                                direction: routeStops.direction,
                                stopUid: routeStop.stopUid,
                                setState: setState),
                            PopupMenuButton(
                              tooltip: "顯示功能選單",
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: const Center(
                                    child: Text(
                                      "顯示公車動態",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BusStatePage(
                                        routeUid: routeStops.routeUid,
                                        initialDirection: routeStops.direction,
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: const Center(
                                    child: Text(
                                      "顯示組站位路線",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => StationDetailPage(
                                          data: routeStop.stopUid,
                                          provideDataType:
                                              StationDetailProvideDataType
                                                  .stopUid),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ).toList(),
      ),
    );
  }
}

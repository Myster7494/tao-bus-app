import 'package:bus_app/src/pages/station_detail_page.dart';
import 'package:bus_app/src/widgets/estimated_time_text.dart';
import 'package:bus_app/src/widgets/favorite_stop_button.dart';
import 'package:bus_app/src/widgets/theme_provider.dart';
import 'package:flutter/material.dart';

import '../bus_data/bus_route.dart';
import '../util.dart';

class BusStatePage extends StatefulWidget {
  final String routeUid;

  const BusStatePage({super.key, required this.routeUid});

  @override
  State<BusStatePage> createState() => _BusStatePageState();
}

class _BusStatePageState extends State<BusStatePage> {
  int direction = 0;

  @override
  Widget build(BuildContext context) {
    BusRoute busRoute = Util.getBusRoute(widget.routeUid)!;
    return ThemeProvider(
      builder: (BuildContext context, ThemeData themeData) => Scaffold(
        appBar: AppBar(title: const Text('公車動態')),
        body: Column(
          children: [
            Text(
              '${busRoute.routeName.zhTw}  |  ${busRoute.headsign}',
              softWrap: true,
              maxLines: 10,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                busRoute.subRoutes.length,
                (index) => Container(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          width: 2.0, color: themeData.colorScheme.primary),
                      backgroundColor: direction == index
                          ? themeData.colorScheme.primary
                          : null,
                    ),
                    onPressed: () => setState(
                        () => direction = busRoute.subRoutes[index].direction),
                    child: Text(
                      "往 ${index == 0 ? busRoute.destinationStopNameZh : busRoute.departureStopNameZh}",
                      style: TextStyle(
                          fontSize: 20,
                          color: direction == index
                              ? themeData.colorScheme.onPrimary
                              : null),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                key: PageStorageKey(direction),
                itemCount:
                    Util.getRouteStopsByDirection(widget.routeUid, direction)!
                        .length,
                itemBuilder: (context, index) {
                  String stopUid = Util.getRouteStopsByDirection(
                          widget.routeUid, direction)![index]
                      .stopUid;
                  return ListTile(
                    title: Text(
                      Util.getBusStop(stopUid)!.stopName.zhTw,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        EstimatedTimeText(
                            routeUid: widget.routeUid,
                            direction: direction,
                            stopUid: stopUid,
                            stopSequence: index + 1),
                        const SizedBox(width: 10),
                        FavoriteStopButton(
                            routeUid: widget.routeUid,
                            direction: direction,
                            stopUid: stopUid,
                            setState: setState),
                        PopupMenuButton(
                            itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: const Center(
                                      child: Text(
                                        "顯示組站位路線",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => StationDetailPage(
                                            data: stopUid,
                                            provideDataType:
                                                StationDetailProvideDataType
                                                    .stopUid),
                                      ),
                                    ),
                                  ),
                                ])
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

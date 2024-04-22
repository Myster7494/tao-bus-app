import 'package:bus_app/src/tdx/estimated_time.dart';
import 'package:flutter/material.dart';

import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:intl/intl.dart';

import '../tdx/loader.dart' show Loader;

class BusStatePage extends MaterialPageRoute {
  final String busRouteUID;

  BusStatePage(
    this.busRouteUID,
  ) : super(
          builder: (context) => BusStatePageWidget(
            busRouteUID: busRouteUID,
          ),
        );
}

class BusStatePageWidget extends StatefulWidget {
  final String busRouteUID;

  const BusStatePageWidget({super.key, required this.busRouteUID});

  @override
  State<BusStatePageWidget> createState() => _BusStatePageWidgetState();
}

class _BusStatePageWidgetState extends State<BusStatePageWidget> {
  int direction = 0;

  @override
  Widget build(BuildContext context) {
    BusRoute busRoute = Loader.busRoutes[widget.busRouteUID]!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${busRoute.routeName.zhTw}\n${busRoute.headsign}'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              busRoute.subRoutes.length,
              (index) => TextButton(
                onPressed: () => setState(
                    () => direction = busRoute.subRoutes[index].direction),
                child: Text(
                    "往 ${index == 0 ? busRoute.destinationStopNameZh : busRoute.departureStopNameZh}"),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              key: PageStorageKey(direction),
              itemCount:
                  Loader.getStopsByDirection(widget.busRouteUID, direction)
                      .length,
              itemBuilder: (context, index) {
                EstimatedTimeData? estimatedTimeData =
                    Loader.estimatedTime.data[widget.busRouteUID]![direction]![
                        Loader.getStopsByDirection(
                                widget.busRouteUID, direction)[index]
                            .stopUid]!;
                return ListTile(
                    title: Text(Loader
                        .busStops[Loader.getStopsByDirection(
                                widget.busRouteUID, direction)[index]
                            .stopUid]!
                        .stopName
                        .zhTw),
                    trailing: Text(estimatedTimeData.estimatedTime != null
                        ? (estimatedTimeData.estimatedTime! == 0
                            ? "進站中"
                            : "${estimatedTimeData.estimatedTime! / 60} 分")
                        : (switch (estimatedTimeData.stopStatus) {
                            1 => (estimatedTimeData.nextBusTime != null
                                ? DateFormat.Hm().format(
                                    estimatedTimeData.nextBusTime!.toLocal())
                                : '尚未發車'),
                            2 => '交管不停靠',
                            3 => '末班車已過',
                            4 => '今日未營運',
                            _ => '未知狀態'
                          })));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          )
        ],
      ),
    );
  }
}

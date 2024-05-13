import 'package:bus_app/src/tdx/estimated_time.dart';
import 'package:flutter/material.dart';

import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:intl/intl.dart';

import '../util/assets_loader.dart' show AssetsLoader;
import '../util/util.dart';

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
    BusRoute busRoute = AssetsLoader.busRoutes[widget.busRouteUID]!;
    late EstimatedTimeData estimatedTimeData;
    return Scaffold(
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
                child: FilledButton(
                  onPressed: () => setState(
                      () => direction = busRoute.subRoutes[index].direction),
                  child: Text(
                    "往 ${index == 0 ? busRoute.destinationStopNameZh : busRoute.departureStopNameZh}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              key: PageStorageKey(direction),
              itemCount: Util.getStopsByDirection(widget.busRouteUID, direction)
                  .length,
              itemBuilder: (context, index) {
                String stopUid = Util.getStopsByDirection(
                        widget.busRouteUID, direction)[index]
                    .stopUid;
                estimatedTimeData = AssetsLoader.estimatedTime
                        .data[widget.busRouteUID]![direction]![stopUid] ??
                    (AssetsLoader.estimatedTime
                            .data[widget.busRouteUID]![direction]!.values)
                        .where((element) =>
                            element.stopSequence ==
                            Util.getStopsByDirection(
                                    widget.busRouteUID, direction)[index]
                                .stopSequence)
                        .first;
                return ListTile(
                  title: Text(
                    AssetsLoader.busStops[stopUid]!.stopName.zhTw,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  trailing: Builder(
                    builder: (context) {
                      if (estimatedTimeData.estimatedTime == null ||
                          estimatedTimeData.estimatedTime! < 0) {
                        return Text(
                          switch (estimatedTimeData.stopStatus) {
                            1 => estimatedTimeData.nextBusTime != null
                                ? DateFormat.Hm().format(
                                    estimatedTimeData.nextBusTime!.toLocal())
                                : '今日未營運',
                            2 => '交管不停靠',
                            3 => '末班車已過',
                            4 => '今日未營運',
                            _ => '未知狀態',
                          },
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        );
                      }
                      String showText = "";
                      Color color = Colors.black;
                      if (estimatedTimeData.isClosestStop) {
                        showText += '${estimatedTimeData.plateNumb} | ';
                      }
                      int estimatedMinutes =
                          estimatedTimeData.estimatedTime! ~/ 60;
                      if (estimatedMinutes <= 1) {
                        showText += "進站中";
                        color = Colors.red;
                      } else {
                        showText += "$estimatedMinutes 分";
                        if (estimatedMinutes <= 3) {
                          color = Colors.orange;
                        }
                      }
                      return Text(
                        showText,
                        style: TextStyle(
                          fontSize: 18,
                          color: color,
                        ),
                      );
                    },
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
    );
  }
}

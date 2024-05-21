import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../bus_data/bus_data_loader.dart';
import '../bus_data/bus_route.dart';
import '../bus_data/estimated_time.dart';

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
    BusRoute busRoute = BusDataLoader.getBusRoute(widget.busRouteUID)!;
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
              itemCount: BusDataLoader.getStopsByDirection(
                      widget.busRouteUID, direction)
                  .length,
              itemBuilder: (context, index) {
                String stopUid = BusDataLoader.getStopsByDirection(
                        widget.busRouteUID, direction)[index]
                    .stopUid;
                estimatedTimeData = BusDataLoader.allEstimatedTime
                        .getEstimatedTimeData(widget.busRouteUID, direction,
                            stopUid: stopUid) ??
                    BusDataLoader.allEstimatedTime.getEstimatedTimeData(
                        widget.busRouteUID, direction,
                        stopSequence: index) ??
                    EstimatedTimeData.noData();
                return ListTile(
                  title: Text(
                    BusDataLoader.getBusStop(stopUid)!.stopName.zhTw,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                        builder: (context) {
                          if (estimatedTimeData.estimatedTime == null ||
                              estimatedTimeData.estimatedTime! < 0) {
                            return Text(
                              switch (estimatedTimeData.stopStatus) {
                                1 => estimatedTimeData.nextBusTime != null
                                    ? DateFormat.Hm().format(estimatedTimeData
                                        .nextBusTime!
                                        .toLocal())
                                    : '今日未營運',
                                2 => '交管不停靠',
                                3 => '末班車已過',
                                4 => '今日未營運',
                                999 => '無資料',
                                _ => '未知狀態',
                              },
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            );
                          }
                          String showText = "";
                          Color color = Colors.black;
                          double fontSize = 18;
                          if (estimatedTimeData.isClosestStop) {
                            showText += '${estimatedTimeData.plateNumb}\n';
                            fontSize = 16;
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
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: color,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Builder(builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {
                            setState(() {});
                          },
                        );
                      }),
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
    );
  }
}

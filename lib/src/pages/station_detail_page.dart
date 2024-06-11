import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:bus_app/src/bus_data/bus_route.dart';
import 'package:bus_app/src/bus_data/group_station.dart';
import 'package:bus_app/src/bus_data/route_stops.dart';
import 'package:bus_app/src/pages/osm_map_page.dart';
import 'package:bus_app/src/widgets/route_popup_menu_button.dart';
import 'package:bus_app/src/widgets/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../bus_data/bus_stop.dart';
import '../util.dart';
import '../widgets/estimated_time_text.dart';
import '../widgets/favorite_stop_button.dart';

enum StationDetailProvideDataType { groupStationUid, stationUid, stopUid }

class StationDetailPage extends StatefulWidget {
  StationDetailPage(
      {super.key,
      required String data,
      required StationDetailProvideDataType provideDataType}) {
    switch (provideDataType) {
      case StationDetailProvideDataType.groupStationUid:
        groupStationUid = data;
        break;
      case StationDetailProvideDataType.stationUid:
        groupStationUid = Util.getBusStation(data)!.groupStationUid;
        break;
      case StationDetailProvideDataType.stopUid:
        groupStationUid = Util.getBusStation(Util.getBusStop(data)!.stationUid)!
            .groupStationUid;
        break;
    }
    groupStation = Util.getGroupStation(groupStationUid)!;
    stations = Map.fromEntries(groupStation.stations.map(
        (stationUid) => MapEntry(stationUid, Util.getBusStation(stationUid)!)));
    stops = stations.map((stationUid, station) => MapEntry(
        stationUid,
        Map.fromEntries(station.stops
            .map((stopUid) => MapEntry(stopUid, Util.getBusStop(stopUid)!)))));
  }

  late final String groupStationUid;
  late final GroupStation groupStation;
  late final BusStationsType stations;
  late final Map<String, BusStopsType> stops;

  @override
  State<StationDetailPage> createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  late final Map<String, bool> isStationSelected;
  late final Map<String, bool> isStopSelected;
  final ValueNotifier<bool> showMap = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    isStationSelected = widget.stations
        .map((stationUid, station) => MapEntry(stationUid, true));
    isStopSelected = Map.fromEntries(widget.stops.values
        .expand((stops) => stops.keys)
        .map((stopUid) => MapEntry(stopUid, true)));
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (BuildContext context, ThemeData themeData) => Scaffold(
        appBar: AppBar(
          title: Text(widget.groupStation.groupStationName.zhTw),
          actions: [
            const Text("顯示地圖"),
            Switch(
                value: showMap.value,
                onChanged: (value) => setState(() => showMap.value = value)),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: showMap,
          builder: (BuildContext context, bool value, Widget? child) => showMap
                  .value
              ? OsmMapPage(
                  initPosition: widget.groupStation.groupStationPosition,
                  extraMarkers: [
                    for (BusStop busStop
                        in widget.stops.values.expand((stops) => stops.values))
                      if (isStopSelected[busStop.stopUid]!)
                        ExtraMarker(
                          name: '站牌 ${busStop.stopUid}',
                          geoPoint: busStop.stopPosition,
                          markerIcon: const MarkerIcon(
                            icon: Icon(
                              Icons.location_on_outlined,
                              size: 36,
                              color: Colors.green,
                            ),
                          ),
                        ),
                  ],
                  showNearGroupStations: false,
                )
              : Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: widget.stations.entries
                          .map(
                            (entry) => Container(
                              margin: const EdgeInsets.all(10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 2.0,
                                      color: themeData.colorScheme.primary),
                                  backgroundColor: isStationSelected[entry.key]!
                                      ? themeData.colorScheme.primary
                                      : null,
                                ),
                                onPressed: () => setState(() {
                                  isStationSelected[entry.key] =
                                      !isStationSelected[entry.key]!;
                                  for (String stationUid
                                      in widget.stations.keys) {
                                    for (String stopUid
                                        in widget.stops[stationUid]!.keys) {
                                      isStopSelected[stopUid] =
                                          isStationSelected[stationUid]!;
                                    }
                                  }
                                }),
                                child: Text(
                                  "往 ${entry.value.bearing.toChinese()}\n(站位${entry.key})",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: isStationSelected[entry.key]!
                                          ? themeData.colorScheme.onPrimary
                                          : null,
                                      height: 1.2),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const Divider(),
                    Wrap(
                        alignment: WrapAlignment.center,
                        children: () {
                          List<Widget> widgets = [];
                          widget.stops.forEach(
                              (String stationUid, BusStopsType busStops) {
                            if (!isStationSelected[stationUid]!) return;
                            for (String busStopUid in busStops.keys) {
                              widgets.add(
                                Container(
                                  margin: const EdgeInsets.all(3),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.all(5),
                                      side: BorderSide(
                                          width: 2.0,
                                          color: themeData.colorScheme.primary),
                                      backgroundColor:
                                          isStopSelected[busStopUid]!
                                              ? themeData.colorScheme.primary
                                              : null,
                                    ),
                                    onPressed: () => setState(() =>
                                        isStopSelected[busStopUid] =
                                            !isStopSelected[busStopUid]!),
                                    child: Text(
                                      "站牌 $busStopUid",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: isStopSelected[busStopUid]!
                                              ? themeData.colorScheme.onPrimary
                                              : null),
                                    ),
                                  ),
                                ),
                              );
                            }
                          });
                          return widgets;
                        }.call()),
                    const Divider(),
                    Expanded(
                      child: Builder(
                        builder: (BuildContext context) {
                          List<RouteStops> routeStopsList = [];
                          for (RouteStops routeStops
                              in BusDataLoader.getAllRouteStopsList()) {
                            for (RouteStop routeStop in routeStops.stops) {
                              if (isStopSelected[routeStop.stopUid] ?? false) {
                                routeStopsList.add(RouteStops(
                                    routeUid: routeStops.routeUid,
                                    direction: routeStops.direction,
                                    stops: [routeStop]));
                              }
                            }
                          }

                          routeStopsList.sort((a, b) => Util.sortRoutes(
                              Util.getBusRoute(a.routeUid)!,
                              Util.getBusRoute(b.routeUid)!));

                          return ListView.separated(
                            itemCount: routeStopsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              BusRoute busRoute = Util.getBusRoute(
                                  routeStopsList[index].routeUid)!;
                              return ListTile(
                                title: Text(
                                  busRoute.routeName.zhTw,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  "${busRoute.headsign} | 往 ${routeStopsList[index].direction == 0 ? busRoute.destinationStopNameZh : busRoute.departureStopNameZh}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    EstimatedTimeText(
                                      routeUid: busRoute.routeUid,
                                      direction:
                                          routeStopsList[index].direction,
                                      stopUid: routeStopsList[index]
                                          .stops
                                          .first
                                          .stopUid,
                                      stopSequence: index + 1,
                                      showPlateNumb: true,
                                    ),
                                    const SizedBox(width: 10),
                                    FavoriteStopButton(
                                        routeUid: busRoute.routeUid,
                                        direction:
                                            routeStopsList[index].direction,
                                        stopUid: routeStopsList[index]
                                            .stops
                                            .first
                                            .stopUid,
                                        setState: setState),
                                    RoutePopupMenuButton(
                                        routeUid: busRoute.routeUid),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(height: 5),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

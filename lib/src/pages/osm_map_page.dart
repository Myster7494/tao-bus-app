import 'dart:async';
import 'dart:math';

import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:bus_app/src/bus_data/bus_route.dart';
import 'package:bus_app/src/bus_data/group_station.dart';
import 'package:bus_app/src/bus_data/real_time_bus.dart';
import 'package:bus_app/src/pages/bus_state_page.dart';
import 'package:bus_app/src/pages/station_detail_page.dart';
import 'package:bus_app/src/widgets/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../util.dart';

enum BoardArgumentsEnum {
  phi,
  latBoard1,
  latBoard2,
  maxLat,
  minLat,
  cosLat,
  lonBoard1,
  lonBoard2,
  maxLon,
  minLon,
}

class ExtraMarker {
  final GeoPoint geoPoint;
  final MarkerIcon markerIcon;
  final List<Widget> Function(BuildContext, ThemeData, GeoPoint?)? infoBuilder;

  const ExtraMarker(
      {required this.geoPoint, required this.markerIcon, this.infoBuilder});
}

class OsmMapPage extends StatefulWidget {
  final GeoPoint? initPosition;
  final List<ExtraMarker> extraMarkers;
  final bool showNearGroupStations;
  final List<GeoPoint> roadPoints;

  const OsmMapPage(
      {super.key,
      this.initPosition,
      this.extraMarkers = const [],
      this.showNearGroupStations = true,
      this.roadPoints = const []});

  @override
  State<StatefulWidget> createState() => _OsmMapPageState();
}

class _OsmMapPageState extends State<OsmMapPage> with TickerProviderStateMixin {
  late GeoPoint initPosition;
  final MarkerIcon groupStationMarkerIcon = const MarkerIcon(
    icon: Icon(
      Icons.location_on_outlined,
      size: 36,
      color: Colors.red,
    ),
  );

  late MapController mapController;
  final Map<String, GeoPoint> displayGroupStations = {};
  final Map<String, RealTimeBus> displayRealTimeBuses = {};
  final ValueNotifier<GeoPoint> myLocation = ValueNotifier(
      GeoPoint(latitude: 24.99290738364926, longitude: 121.30105867981855));
  final ValueNotifier<bool> trackingNotifier = ValueNotifier(true);
  final ValueNotifier<bool> showAllGroupStations = ValueNotifier(false);
  final ValueNotifier<bool> showRealTimeBuses = ValueNotifier(false);
  final ValueNotifier<
          List<Widget> Function(BuildContext, ThemeData, GeoPoint?)?>
      infoBuilder = ValueNotifier(null);
  Timer? timer;
  late AnimationController animationController;

  final Map<BoardArgumentsEnum, double> boardArguments = {};

  void calculateBoard() {
    boardArguments[BoardArgumentsEnum.phi] =
        myLocation.value.latitude * Util.rad;
    boardArguments[BoardArgumentsEnum.latBoard1] =
        myLocation.value.latitude - 0.009;
    boardArguments[BoardArgumentsEnum.latBoard2] =
        myLocation.value.latitude + 0.009;
    boardArguments[BoardArgumentsEnum.maxLat] = max(
        boardArguments[BoardArgumentsEnum.latBoard1]!,
        boardArguments[BoardArgumentsEnum.latBoard2]!);
    boardArguments[BoardArgumentsEnum.minLat] = min(
        boardArguments[BoardArgumentsEnum.latBoard1]!,
        boardArguments[BoardArgumentsEnum.latBoard2]!);
    boardArguments[BoardArgumentsEnum.cosLat] =
        0.009 / cos(myLocation.value.latitude * Util.rad);
    boardArguments[BoardArgumentsEnum.lonBoard1] =
        myLocation.value.longitude - boardArguments[BoardArgumentsEnum.cosLat]!;
    boardArguments[BoardArgumentsEnum.lonBoard2] =
        myLocation.value.longitude + boardArguments[BoardArgumentsEnum.cosLat]!;
    boardArguments[BoardArgumentsEnum.maxLon] = max(
        boardArguments[BoardArgumentsEnum.lonBoard1]!,
        boardArguments[BoardArgumentsEnum.lonBoard2]!);
    boardArguments[BoardArgumentsEnum.minLon] = min(
        boardArguments[BoardArgumentsEnum.lonBoard1]!,
        boardArguments[BoardArgumentsEnum.lonBoard2]!);
  }

  bool inOneKm(GeoPoint geoPoint) {
    if (!(geoPoint.latitude >= boardArguments[BoardArgumentsEnum.minLat]! &&
        geoPoint.latitude <= boardArguments[BoardArgumentsEnum.maxLat]! &&
        geoPoint.longitude >= boardArguments[BoardArgumentsEnum.minLon]! &&
        geoPoint.longitude <= boardArguments[BoardArgumentsEnum.maxLon]!)) {
      return false;
    }
    final double a = sqrtSin(
            (geoPoint.latitude - myLocation.value.latitude) * Util.halfRad) +
        sqrtCos2(boardArguments[BoardArgumentsEnum.phi]!,
                geoPoint.latitude * Util.rad) *
            sqrtSin((geoPoint.longitude - myLocation.value.longitude) *
                Util.halfRad);
    if (a / (1 - a) <= 6.159e-9) return true;
    return false;
  }

  Future<void> limitArea() async {
    await mapController.removeLimitAreaMap();
    final double latBoard1 = myLocation.value.latitude - 0.012;
    final double latBoard2 = myLocation.value.latitude + 0.012;
    final double maxLat = max(latBoard1, latBoard2);
    final double minLat = min(latBoard1, latBoard2);
    final double cosLat = 0.012 / cos(myLocation.value.latitude * Util.rad);
    final double lonBoard1 = myLocation.value.longitude - cosLat;
    final double lonBoard2 = myLocation.value.longitude + cosLat;
    final double maxLon = max(lonBoard1, lonBoard2);
    final double minLon = min(lonBoard1, lonBoard2);
    await Future.delayed(const Duration(seconds: 1));
    await mapController.limitAreaMap(
        BoundingBox(north: maxLat, east: maxLon, south: minLat, west: minLon));
  }

  Future<void> drawMyLocation() async {
    await mapController.removeMarker(myLocation.value);
    await updateMyLocation();
    if (trackingNotifier.value) {
      await mapController.moveTo(myLocation.value);
    }
    await mapController.addMarker(
      myLocation.value,
      markerIcon: const MarkerIcon(
        icon: Icon(
          Icons.my_location,
          size: 36,
          color: Colors.blue,
        ),
      ),
    );
  }

  Future<void> updateMyLocation() async {
    if (await Util.hasGps()) {
      if (!kIsWeb) {
        myLocation.value =
            Util.positionToGeoPoint((await Geolocator.getLastKnownPosition())!);
      } else {
        try {
          myLocation.value = Util.positionToGeoPoint(
              await Geolocator.getCurrentPosition(
                  timeLimit: const Duration(seconds: 5)));
        } on TimeoutException {
          debugPrint("Get gps time out.");
        }
      }
    }
    if (trackingNotifier.value) {
      await limitArea();
    } else {
      await mapController.removeLimitAreaMap();
    }
    if (!showAllGroupStations.value) await _drawNearGroupStations();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initPosition == null) {
      initPosition = myLocation.value;
    } else {
      initPosition = widget.initPosition!;
      trackingNotifier.value = false;
      showAllGroupStations.value = false;
    }
    mapController = MapController.withPosition(
      initPosition: initPosition,
    );
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
  }

  Future<void> mapIsReady(bool isReady) async {
    if (widget.roadPoints.isNotEmpty) {
      await mapController.drawRoadManually(
        widget.roadPoints,
        const RoadOption(
          roadColor: Colors.blue,
          roadWidth: 5,
        ),
      );
    }
    for (ExtraMarker extraMarker in widget.extraMarkers) {
      await mapController.addMarker(
        extraMarker.geoPoint,
        markerIcon: extraMarker.markerIcon,
      );
    }
    await drawMyLocation();
    Geolocator.getPositionStream()
        .listen((Position position) async => await drawMyLocation());
    await onRegionChanged();
  }

  // Future<void> onLocationChanged(GeoPoint userLocation) async {
  //   await updateMyLocation();
  // }

  Future<void> onRegionChanged([Region? region]) async {
    region ??= Region(
      center: await mapController.centerMap,
      boundingBox: await mapController.bounds,
    );
    if (!trackingNotifier.value) await mapController.removeLimitAreaMap();

    calculateBoard();

    for (GroupStation groupStation in BusDataLoader.groupStations.values) {
      bool inRegion =
          region.boundingBox.inBoundingBox(groupStation.groupStationPosition);
      bool inDisplayGroupStations =
          displayGroupStations.containsKey(groupStation.groupStationUid);
      if ((showAllGroupStations.value ||
              (inOneKm(groupStation.groupStationPosition) &&
                  widget.showNearGroupStations)) &&
          inRegion &&
          !inDisplayGroupStations) {
        displayGroupStations[groupStation.groupStationUid] =
            groupStation.groupStationPosition;
        await mapController.addMarker(
          groupStation.groupStationPosition,
          markerIcon: groupStationMarkerIcon,
        );
      } else if ((!showAllGroupStations.value || !inRegion) &&
          !inOneKm(groupStation.groupStationPosition) &&
          inDisplayGroupStations &&
          !widget.extraMarkers.map((extraMarker) => extraMarker.geoPoint).any(
              (element) =>
                  element.isEqual(groupStation.groupStationPosition))) {
        displayGroupStations.remove(groupStation.groupStationUid);
        await mapController.removeMarker(groupStation.groupStationPosition);
      }
    }

    for (RealTimeBus realTimeBus
        in BusDataLoader.getDefaultAllRealTimeBusesList()) {
      bool inRegion = region.boundingBox.inBoundingBox(realTimeBus.busPosition);
      bool inDisplayRealTimeBuses =
          displayRealTimeBuses.containsKey(realTimeBus.plateNumb);
      if (inRegion && !inDisplayRealTimeBuses && showRealTimeBuses.value) {
        displayRealTimeBuses[realTimeBus.plateNumb] = realTimeBus;
        await mapController.addMarker(
          realTimeBus.busPosition,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.directions_bus,
              size: 36,
              color: Colors.orange,
            ),
          ),
        );
      } else if ((!showRealTimeBuses.value || !inRegion) &&
          inDisplayRealTimeBuses) {
        displayRealTimeBuses.remove(realTimeBus.plateNumb);
        await mapController.removeMarker(realTimeBus.busPosition);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null && timer!.isActive) timer?.cancel();
    animationController.dispose();
    mapController.dispose();
  }

  Future<void> _drawNearGroupStations() async {
    if (!widget.showNearGroupStations) return;
    try {
      await mapController.removeCircle("nearCircle");
    } catch (e) {
      debugPrint(e.toString());
    }
    await mapController.drawCircle(
      CircleOSM(
        key: "nearCircle",
        centerPoint: myLocation.value,
        radius: 1000,
        color: Colors.green.withAlpha(10),
        borderColor: Colors.green,
        strokeWidth: 3,
      ),
    );

    for (GroupStation groupStation in BusDataLoader.groupStations.values) {
      if (!displayGroupStations.containsKey(groupStation.groupStationUid) &&
          inOneKm(groupStation.groupStationPosition)) {
        displayGroupStations[groupStation.groupStationUid] =
            groupStation.groupStationPosition;
        await mapController.addMarker(
          groupStation.groupStationPosition,
          markerIcon: groupStationMarkerIcon,
        );
      } else if (displayGroupStations
              .containsKey(groupStation.groupStationUid) &&
          !inOneKm(groupStation.groupStationPosition) &&
          !widget.extraMarkers.map((extraMarker) => extraMarker.geoPoint).any(
              (element) =>
                  element.isEqual(groupStation.groupStationPosition))) {
        displayGroupStations.remove(groupStation.groupStationUid);
        await mapController.removeMarker(groupStation.groupStationPosition);
      }
    }
  }

  void onGeoPointClicked(BuildContext context, GeoPoint geoPoint) async {
    if (geoPoint == myLocation.value) {
      infoBuilder.value = (BuildContext context, _, __) =>
          [const Text('我的位置', style: TextStyle(fontSize: 20))];
      return;
    }
    bool isExtraMarker = widget.extraMarkers
        .map((extraMarker) => extraMarker.geoPoint)
        .any((element) => element.isEqual(geoPoint));
    bool isRealTimeBus = displayRealTimeBuses.values
        .map((realTimeBus) => realTimeBus.busPosition)
        .any((element) => element.isEqual(geoPoint));
    if (isExtraMarker) {
      infoBuilder.value = widget.extraMarkers
          .firstWhere((extraMarker) => extraMarker.geoPoint.isEqual(geoPoint))
          .infoBuilder;
      return;
    }
    if (isRealTimeBus) {
      RealTimeBus realTimeBus = displayRealTimeBuses.values.firstWhere(
          (realTimeBus) => realTimeBus.busPosition.isEqual(geoPoint));
      BusRoute busRoute = Util.getBusRoute(realTimeBus.routeUid)!;
      infoBuilder.value = (BuildContext context, _, __) => [
            Text(
                '${realTimeBus.plateNumb} | ${busRoute.routeName.zhTw} | 往 ${realTimeBus.direction == 0 ? busRoute.destinationStopNameZh : busRoute.departureStopNameZh} | ${realTimeBus.operatorNo.toChinese()}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 5),
            FilledButton(
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(5)),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      BusStatePage(routeUid: realTimeBus.routeUid),
                ),
              ),
              child: const Text("顯示公車路線"),
            ),
          ];
      return;
    }
    String groupStationUid = displayGroupStations.entries
        .firstWhere((mapEntry) => mapEntry.value.isEqual(geoPoint),
            orElse: () => MapEntry("-1", GeoPoint(latitude: 0, longitude: 0)))
        .key;
    if (groupStationUid == "-1") {
      await mapController.removeMarker(geoPoint);
      return;
    }
    infoBuilder.value =
        (BuildContext context, ThemeData themeData, GeoPoint? myLocation) {
      String text =
          Util.getGroupStation(groupStationUid)!.groupStationName.zhTw;
      if (myLocation != null) {
        double distance = Util.twoGeoPointsDistance(
          myLocation,
          geoPoint,
        );
        if (distance > 1000) {
          text += ' | ${(distance / 1000).toStringAsFixed(2)} km';
        } else {
          text += ' | ${distance.round()} m';
        }
      }
      return [
        Text(text, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 5),
        FilledButton(
          style: FilledButton.styleFrom(padding: const EdgeInsets.all(5)),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StationDetailPage(
                  data: groupStationUid,
                  provideDataType:
                      StationDetailProvideDataType.groupStationUid),
            ),
          ),
          child: const Text("顯示組站位路線"),
        ),
      ];
    };
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (BuildContext context, ThemeData themeData) {
        Widget widgetBuilder(BuildContext context, bool enableGps) {
          if (!enableGps) {
            trackingNotifier.value = false;
            showAllGroupStations.value = widget.extraMarkers.isEmpty;
          }
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                Stack(
              alignment: Alignment.center,
              children: [
                OSMFlutter(
                  controller: mapController,
                  mapIsLoading: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  osmOption: const OSMOption(
                    enableRotationByGesture: true,
                    zoomOption: ZoomOption(
                      initZoom: 16,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                      stepZoom: 1.0,
                    ),
                    // userLocationMarker: UserLocationMaker(
                    //   personMarker: const MarkerIcon(
                    //     icon: Icon(
                    //       Icons.my_location,
                    //       size: 36,
                    //       color: Colors.blue,
                    //     ),
                    //   ),
                    //   directionArrowMarker: const MarkerIcon(
                    //     icon: Icon(
                    //       Icons.my_location,
                    //       size: 36,
                    //       color: Colors.blue,
                    //     ),
                    //   ),
                    // ),
                  ),
                  onGeoPointClicked: (geoPoint) =>
                      onGeoPointClicked(context, geoPoint),
                  onMapIsReady: mapIsReady,
                  onMapMoved: (Region region) async {
                    await onRegionChanged(region);
                  },
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PointerInterceptor(
                        child: FilledButton(
                          onPressed: () async =>
                              await Util.requestGpsPermission(),
                          child: const Text('更新GPS狀態'),
                        ),
                      ),
                      const SizedBox(height: 5),
                      PointerInterceptor(
                        child: FilledButton(
                          onPressed: () async {
                            try {
                              await mapController.removeCircle("nearCircle");
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            for (ExtraMarker extraMarker
                                in widget.extraMarkers) {
                              await mapController
                                  .removeMarker(extraMarker.geoPoint);
                            }
                            for (GeoPoint geoPoint
                                in displayGroupStations.values) {
                              await mapController.removeMarker(geoPoint);
                            }
                            displayGroupStations.clear();
                            for (RealTimeBus realTimeBus
                                in displayRealTimeBuses.values) {
                              await mapController
                                  .removeMarker(realTimeBus.busPosition);
                            }
                            await Future.delayed(const Duration(seconds: 1));
                            for (ExtraMarker extraMarker
                                in widget.extraMarkers) {
                              await mapController.addMarker(
                                extraMarker.geoPoint,
                                markerIcon: extraMarker.markerIcon,
                              );
                            }
                          },
                          child: const Text('清除圖標'),
                        ),
                      ),
                      if (widget.initPosition != null) ...[
                        const SizedBox(height: 5),
                        PointerInterceptor(
                          child: FilledButton(
                            onPressed: () async => await mapController
                                .moveTo(widget.initPosition!),
                            child: const Text('返回標記定位點'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: PointerInterceptor(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.secondaryContainer,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            border: Border.all(
                                width: 3, color: themeData.colorScheme.primary),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async =>
                                    await mapController.zoomIn(),
                                icon: const Icon(Icons.zoom_in),
                              ),
                              const SizedBox(height: 5),
                              IconButton(
                                onPressed: () async =>
                                    await mapController.setZoom(zoomLevel: 16),
                                icon: const Icon(Icons.zoom_out_map),
                              ),
                              const SizedBox(height: 5),
                              IconButton(
                                onPressed: () async =>
                                    await mapController.zoomOut(),
                                icon: const Icon(Icons.zoom_out),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        FloatingActionButton(
                          onPressed: () async {
                            trackingNotifier.value = !trackingNotifier.value;
                            await mapController.removeLimitAreaMap();
                            if (trackingNotifier.value) {
                              await mapController.moveTo(myLocation.value);
                              if (enableGps) await limitArea();
                            } else {
                              await mapController.removeLimitAreaMap();
                            }
                          },
                          child: Builder(builder: (BuildContext context) {
                            if (!enableGps) {
                              return const Icon(Icons.gps_off);
                            }
                            return ValueListenableBuilder<bool>(
                              valueListenable: trackingNotifier,
                              builder: (BuildContext context, bool value,
                                      Widget? child) =>
                                  value
                                      ? const Icon(Icons.my_location)
                                      : const Icon(Icons.gps_not_fixed),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: PointerInterceptor(
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.secondaryContainer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        border: Border.all(
                            width: 3, color: themeData.colorScheme.primary),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("顯示所有組站位"),
                              const SizedBox(width: 5),
                              ValueListenableBuilder(
                                valueListenable: showAllGroupStations,
                                builder: (BuildContext context, bool value,
                                        Widget? child) =>
                                    Switch(
                                  value: value,
                                  activeColor: themeData.colorScheme.primary,
                                  onChanged: (bool value) async {
                                    if (!enableGps &&
                                        widget.extraMarkers.isEmpty) {
                                      return;
                                    }
                                    showAllGroupStations.value = value;
                                    if (!value) {
                                      await updateMyLocation();
                                    }
                                    await onRegionChanged();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("顯示公車位置"),
                              const SizedBox(width: 5),
                              ValueListenableBuilder(
                                valueListenable: showRealTimeBuses,
                                builder: (BuildContext context, bool value,
                                        Widget? child) =>
                                    Switch(
                                  value: value,
                                  activeColor: themeData.colorScheme.primary,
                                  onChanged: (bool value) async {
                                    showRealTimeBuses.value = value;
                                    if (!value) {
                                      await updateMyLocation();
                                    }
                                    await onRegionChanged();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: infoBuilder,
                  builder: (context,
                      List<Widget> Function(BuildContext, ThemeData, GeoPoint?)?
                          builder,
                      _) {
                    if (builder == null) return const SizedBox.shrink();
                    return Positioned(
                      bottom: 16,
                      child: PointerInterceptor(
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeData.colorScheme.secondaryContainer,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                                border: Border.all(
                                    width: 3,
                                    color: themeData.colorScheme.primary),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: builder(context, themeData,
                                    Util.enableGps! ? myLocation.value : null)
                                  ..add(IconButton(
                                    padding: const EdgeInsets.all(5),
                                    onPressed: () => infoBuilder.value = null,
                                    icon: const Icon(Icons.close),
                                  )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        if (Util.enableGps != null) {
          return widgetBuilder(context, Util.enableGps!);
        }
        return FutureBuilder(
          future: Util.hasGps(),
          builder: (BuildContext context, AsyncSnapshot<bool> myPosSnapshot) {
            if (myPosSnapshot.connectionState != ConnectionState.done ||
                !myPosSnapshot.hasData) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("正在請求位置"),
                  ],
                ),
              );
            }
            return widgetBuilder(context, myPosSnapshot.data!);
          },
        );
      },
    );
  }
}

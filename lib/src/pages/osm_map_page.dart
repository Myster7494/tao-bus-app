import 'dart:async';
import 'dart:math';

import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:bus_app/src/bus_data/group_station.dart';
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

class OsmMapPage extends StatefulWidget {
  const OsmMapPage({super.key});

  @override
  State<StatefulWidget> createState() => _OsmMapPageState();
}

class _OsmMapPageState extends State<OsmMapPage> with TickerProviderStateMixin {
  MarkerIcon groupStationMarkerIcon = const MarkerIcon(
    icon: Icon(
      Icons.location_on_outlined,
      size: 36,
      color: Colors.red,
    ),
  );

  //Key key = UniqueKey();
  late MapController mapController;
  final Map<String, GeoPoint> displayGroupStations = {};
  ValueNotifier<GeoPoint> myLocation = ValueNotifier(
      GeoPoint(latitude: 24.99290738364926, longitude: 121.30105867981855));
  ValueNotifier<bool> trackingNotifier = ValueNotifier(true);
  ValueNotifier<bool> showAllGroupStations = ValueNotifier(false);
  Timer? timer;
  late AnimationController animationController;

  Map<BoardArgumentsEnum, double> boardArguments = {};

  get enableGps => Util.enableGps;

  set enableGps(value) => Util.enableGps = value;

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

  Future<bool> hasGps() async {
    if (enableGps != null) return enableGps!;

    enableGps = false;
    LocationPermission permission;
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    if (!kIsWeb) return (await Geolocator.getLastKnownPosition() != null);
    try {
      await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 5));
      enableGps = true;
      return true;
    } on TimeoutException {
      return false;
    }
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

  Future<void> updateMyLocation() async {
    if (await hasGps()) {
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
    mapController = MapController.withPosition(
      initPosition: myLocation.value,
    );
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
  }

  Future<void> mapIsReady(bool isReady) async {
    Geolocator.getPositionStream().listen((Position position) async {
      await updateMyLocation();
      if (trackingNotifier.value) {
        await mapController.moveTo(myLocation.value);
      }
    });
    await updateMyLocation();
    await onRegionChanged();
    //await mapController.moveTo(myLocation.value);
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
      //debugPrint(groupStation.groupStationName.zhTw);
      bool inRegion =
          region.boundingBox.inBoundingBox(groupStation.groupStationPosition);
      bool inDisplayGroupStations =
          displayGroupStations.containsKey(groupStation.groupStationUid);
      if ((showAllGroupStations.value ||
              inOneKm(groupStation.groupStationPosition)) &&
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
          inDisplayGroupStations) {
        displayGroupStations.remove(groupStation.groupStationUid);
        await mapController.removeMarker(groupStation.groupStationPosition);
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
    //await mapController.removeCircle("nearCircle");

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
          !inOneKm(groupStation.groupStationPosition)) {
        displayGroupStations.remove(groupStation.groupStationUid);
        await mapController.removeMarker(groupStation.groupStationPosition);
      }
    }
  }

  void onGeoPointClicked(BuildContext context, GeoPoint geoPoint) async {
    String groupStationUid = displayGroupStations.entries
        .firstWhere((mapEntry) => mapEntry.value.isEqual(geoPoint),
            orElse: () => MapEntry("-1", GeoPoint(latitude: 0, longitude: 0)))
        .key;
    if (groupStationUid == "-1") {
      await mapController.removeMarker(geoPoint);
      return;
    }
    GroupStation? clickGroupStation =
        BusDataLoader.getGroupStation(groupStationUid);
    if (clickGroupStation != null) {
      double distance = Util.twoGeoPointsDistance(
        myLocation.value,
        geoPoint,
      );
      if (distance > 1000) {
        Util.showSnackBar(
          context,
          '${clickGroupStation.groupStationName.zhTw} | ${(distance / 1000).toStringAsFixed(2)} km',
        );
        return;
      }
      Util.showSnackBar(
        context,
        '${clickGroupStation.groupStationName.zhTw} | ${distance.round()} m',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (BuildContext context, ThemeData themeData) {
        Widget widgetBuilder(BuildContext context, bool enableGps) {
          if (!enableGps) {
            trackingNotifier.value = false;
            showAllGroupStations.value = true;
          }
          return Stack(
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
                bottom: 16,
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
                          // if (!trackingNotifier.value && !await hasGps()) {
                          //   if (context.mounted) {
                          //     Util.showSnackBar(
                          //       context,
                          //       "無法取得位置",
                          //       action: SnackBarAction(
                          //         label: "返回「桃園市政府」",
                          //         onPressed: () async => await mapController
                          //             .moveTo(myLocation.value),
                          //       ),
                          //     );
                          //   }
                          //   return;
                          // }
                          trackingNotifier.value = !trackingNotifier.value;
                          await mapController.removeLimitAreaMap();
                          if (trackingNotifier.value) {
                            await mapController.moveTo(myLocation.value);
                            await limitArea();
                          } else {
                            await mapController.removeLimitAreaMap();
                          }
                        },
                        child: FutureBuilder(
                            future: hasGps(),
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> myPosSnapshot) {
                              if (!myPosSnapshot.hasData ||
                                  !myPosSnapshot.data!) {
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
                bottom: 16,
                left: 16,
                child: PointerInterceptor(
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeData.colorScheme.secondaryContainer,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      border: Border.all(
                          width: 3, color: themeData.colorScheme.primary),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 5),
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
                              showAllGroupStations.value = value;
                              if (value) {
                                await onRegionChanged();
                              } else {
                                await updateMyLocation();
                                await onRegionChanged();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        if (enableGps != null) {
          return widgetBuilder(context, enableGps!);
        }
        return FutureBuilder(
          future: hasGps(),
          builder: (BuildContext context, AsyncSnapshot<bool> myPosSnapshot) {
            if (myPosSnapshot.connectionState != ConnectionState.done ||
                !myPosSnapshot.hasData) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
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

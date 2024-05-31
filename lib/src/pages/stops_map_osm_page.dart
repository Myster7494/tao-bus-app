import 'dart:async';
import 'dart:math';

import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:bus_app/src/bus_data/group_station.dart';
import 'package:bus_app/src/widgets/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../util.dart';

class NearStopsOsmPage extends StatefulWidget {
  const NearStopsOsmPage({super.key});

  @override
  State<StatefulWidget> createState() => _NearStopsOsmPageState();
}

class _NearStopsOsmPageState extends State<NearStopsOsmPage>
    with OSMMixinObserver, TickerProviderStateMixin {
  late MapController mapController;
  final Map<String, GeoPoint> displayGroupStations = {};
  ValueNotifier<GeoPoint?> myLocation = ValueNotifier(null);
  ValueNotifier<bool> trackingNotifier = ValueNotifier(true);
  ValueNotifier<bool> showAllGroupStations = ValueNotifier(false);
  Timer? timer;
  late AnimationController animationController;

  Future<void> limitArea() async {
    await mapController.removeLimitAreaMap();
    final double latBoard1 = myLocation.value!.latitude - 0.012;
    final double latBoard2 = myLocation.value!.latitude + 0.012;
    final double maxLat = max(latBoard1, latBoard2);
    final double minLat = min(latBoard1, latBoard2);
    final double cosLat = 0.012 / cos(myLocation.value!.latitude * Util.rad);
    final double lonBoard1 = myLocation.value!.longitude - cosLat;
    final double lonBoard2 = myLocation.value!.longitude + cosLat;
    final double maxLon = max(lonBoard1, lonBoard2);
    final double minLon = min(lonBoard1, lonBoard2);
    await Future.delayed(const Duration(seconds: 1));
    await mapController.limitAreaMap(
        BoundingBox(north: maxLat, east: maxLon, south: minLat, west: minLon));
  }

  Future<void> updateMyLocation() async {
    myLocation.value = await mapController.myLocation();
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
    mapController = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
    );
    mapController.addObserver(this);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    await mapController.setZoom(zoomLevel: 16);
    await updateMyLocation();
  }

  @override
  Future<void> onLocationChanged(UserLocation userLocation) async {
    super.onLocationChanged(userLocation);
    await updateMyLocation();
  }

  @override
  void onRegionChanged(Region region) {
    super.onRegionChanged(region);
    if (!trackingNotifier.value) mapController.removeLimitAreaMap();
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null && timer!.isActive) timer?.cancel();
    animationController.dispose();
    mapController.dispose();
  }

  Future<void> _drawAllGroupStations() async {
    for (GroupStation groupStation in BusDataLoader.groupStations.values) {
      if (!displayGroupStations.containsKey(groupStation.groupStationUid)) {
        final GeoPoint stationGeoPoint =
            groupStation.groupStationPosition.toGeoPoint();
        await mapController.addMarker(
          stationGeoPoint,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on_outlined,
              size: 36,
              color: Colors.red,
            ),
          ),
        );
        displayGroupStations[groupStation.groupStationUid] = stationGeoPoint;
      }
    }
  }

  Future<void> _drawNearGroupStations() async {
    if (myLocation.value == null) return;
    await mapController.removeCircle("nearStopsCircle");

    final phi = myLocation.value!.latitude * Util.rad;
    final double latBoard1 = myLocation.value!.latitude - 0.009;
    final double latBoard2 = myLocation.value!.latitude + 0.009;
    final double maxLat = max(latBoard1, latBoard2);
    final double minLat = min(latBoard1, latBoard2);
    final double cosLat = 0.009 / cos(myLocation.value!.latitude * Util.rad);
    final double lonBoard1 = myLocation.value!.longitude - cosLat;
    final double lonBoard2 = myLocation.value!.longitude + cosLat;
    final double maxLon = max(lonBoard1, lonBoard2);
    final double minLon = min(lonBoard1, lonBoard2);

    bool inOneKm(double lat, double lon) {
      if (!(lat >= minLat && lat <= maxLat && lon >= minLon && lon <= maxLon)) {
        return false;
      }
      final double a =
          sqrtSin((lat - myLocation.value!.latitude) * Util.halfRad) +
              sqrtCos2(phi, lat * Util.rad) *
                  sqrtSin((lon - myLocation.value!.longitude) * Util.halfRad);
      if (a / (1 - a) <= 6.159e-9) return true;
      return false;
    }

    final Map<String, GeoPoint> removeGroupStations = {};
    displayGroupStations.forEach((groupStationUid, geoPoint) {
      if (!inOneKm(geoPoint.latitude, geoPoint.longitude)) {
        removeGroupStations[groupStationUid] = geoPoint;
      }
    });
    for (String groupStationUid in removeGroupStations.keys) {
      displayGroupStations.remove(groupStationUid);
    }
    await mapController.removeMarkers(removeGroupStations.values.toList());
    await mapController.drawCircle(
      CircleOSM(
        key: "nearStopsCircle",
        centerPoint: myLocation.value!,
        radius: 1000,
        color: Colors.green.withAlpha(10),
        borderColor: Colors.green,
        strokeWidth: 3,
      ),
    );
    for (GroupStation groupStation in BusDataLoader.groupStations.values) {
      if (!displayGroupStations.containsKey(groupStation.groupStationUid) &&
          !removeGroupStations.containsKey(groupStation.groupStationUid) &&
          inOneKm(groupStation.groupStationPosition.positionLat,
              groupStation.groupStationPosition.positionLon)) {
        final GeoPoint stationGeoPoint =
            groupStation.groupStationPosition.toGeoPoint();
        await mapController.addMarker(
          stationGeoPoint,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on_outlined,
              size: 36,
              color: Colors.red,
            ),
          ),
        );
        displayGroupStations[groupStation.groupStationUid] = stationGeoPoint;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (BuildContext context, ThemeData themeData) => Stack(
        children: [
          OSMFlutter(
            controller: mapController,
            mapIsLoading: const Center(
              child: CircularProgressIndicator(),
            ),
            osmOption: OSMOption(
              enableRotationByGesture: true,
              zoomOption: const ZoomOption(
                initZoom: 16,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.my_location,
                    size: 36,
                    color: Colors.blue,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.my_location,
                    size: 36,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            onGeoPointClicked: (geoPoint) {
              GroupStation? clickGroupStation = BusDataLoader.getGroupStation(
                  displayGroupStations.entries
                      .firstWhere(
                          (mapEntry) => mapEntry.value.isEqual(geoPoint))
                      .key);
              if (clickGroupStation != null) {
                Util.showSnackBar(
                  context,
                  clickGroupStation.groupStationName.zhTw,
                );
              }
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
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      border: Border.all(
                          width: 3, color: themeData.colorScheme.primary),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async => await mapController.zoomIn(),
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
                          onPressed: () async => await mapController.zoomOut(),
                          icon: const Icon(Icons.zoom_out),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () async {
                      await mapController.removeLimitAreaMap();
                      if (!trackingNotifier.value) {
                        await mapController.currentLocation();
                        await mapController.enableTracking(
                          enableStopFollow: true,
                          disableUserMarkerRotation: false,
                          anchor: Anchor.left,
                        );
                      } else {
                        await mapController.disabledTracking();
                      }
                      trackingNotifier.value = !trackingNotifier.value;

                      if (trackingNotifier.value) {
                        await limitArea();
                        await Future.delayed(const Duration(milliseconds: 500));
                        await mapController.setZoom(zoomLevel: 16);
                      } else {
                        await mapController.removeLimitAreaMap();
                      }
                    },
                    child: ValueListenableBuilder<bool>(
                      valueListenable: trackingNotifier,
                      builder:
                          (BuildContext context, bool value, Widget? child) =>
                              value
                                  ? const Icon(Icons.my_location)
                                  : const Icon(Icons.gps_not_fixed),
                    ),
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
                      builder:
                          (BuildContext context, bool value, Widget? child) =>
                              Switch(
                        value: value,
                        activeColor: themeData.colorScheme.primary,
                        onChanged: (bool value) {
                          showAllGroupStations.value = value;
                          if (value) {
                            _drawAllGroupStations();
                          } else {
                            _drawNearGroupStations();
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
      ),
    );
  }
}

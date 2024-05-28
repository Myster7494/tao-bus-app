import 'dart:async';
import 'dart:math';

import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:bus_app/src/widgets/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../bus_data/bus_station.dart';
import '../util.dart';

class NearStopsOsmPage extends StatefulWidget {
  const NearStopsOsmPage({super.key});

  @override
  State<StatefulWidget> createState() => _NearStopsOsmPageState();
}

class _NearStopsOsmPageState extends State<NearStopsOsmPage>
    with OSMMixinObserver, TickerProviderStateMixin {
  late MapController mapController;
  final Map<String, GeoPoint> nearStations = {};
  late GeoPoint myLocation;
  ValueNotifier<GeoPoint?> centerMap = ValueNotifier(null);
  ValueNotifier<bool> trackingNotifier = ValueNotifier(true);
  Timer? timer;
  late AnimationController animationController;
  late Animation<double> animation =
      Tween<double>(begin: 0, end: 2 * pi).animate(animationController);

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
    mapController.listenerRegionIsChanging.addListener(() async {
      if (mapController.listenerRegionIsChanging.value != null) {
        centerMap.value = mapController.listenerRegionIsChanging.value!.center;
      }
    });
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
    myLocation = await mapController.myLocation();
    await _drawNearStops();
  }

  @override
  void dispose() {
    if (timer != null && timer!.isActive) timer?.cancel();
    animationController.dispose();
    mapController.dispose();
    super.dispose();
  }

  Future<void> _drawNearStops() async {
    final phi = myLocation.latitude * Util.rad;
    final double latBoard1 = myLocation.latitude - 0.009;
    final double latBoard2 = myLocation.latitude + 0.009;
    final double cosLat = 0.009 / cos(myLocation.latitude * Util.rad);
    final double lonBoard1 = myLocation.longitude - cosLat;
    final double lonBoard2 = myLocation.longitude + cosLat;

    bool inOneKm(double lat, double lon) {
      if (!(lat >= latBoard1 &&
          myLocation.latitude <= latBoard2 &&
          lon >= lonBoard1 &&
          myLocation.longitude <= lonBoard2)) {
        return false;
      }
      final double a = sqrtSin((lat - myLocation.latitude) * Util.rad / 2) +
          sqrtCos2(phi, lat * Util.rad) *
              sqrtSin((lon - myLocation.longitude) * Util.rad / 2);
      if (a / (1 - a) <= 6.159e-9) return true;
      return false;
    }

    final Map<String, GeoPoint> removeStations = {};
    nearStations.forEach((stationUid, geoPoint) {
      if (!inOneKm(geoPoint.latitude, geoPoint.longitude)) {
        removeStations[stationUid] = geoPoint;
      }
    });
    for (String stationUid in removeStations.keys) {
      nearStations.remove(stationUid);
    }
    await mapController.removeMarkers(removeStations.values.toList());
    await mapController.removeCircle("nearStopsCircle");
    await mapController.drawCircle(
      CircleOSM(
        key: "nearStopsCircle",
        centerPoint: myLocation,
        radius: 1000,
        color: Colors.green.withAlpha(10),
        borderColor: Colors.green,
        strokeWidth: 3,
      ),
    );
    for (BusStation busStation in BusDataLoader.busStations.values) {
      if (!nearStations.containsKey(busStation.stationUid) &&
          !removeStations.containsKey(busStation.stationUid) &&
          inOneKm(busStation.stationPosition.positionLat,
              busStation.stationPosition.positionLon)) {
        final GeoPoint stationGeoPoint =
            busStation.stationPosition.toGeoPoint();
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
        nearStations[busStation.stationUid] = stationGeoPoint;
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
            onLocationChanged: (_) async {
              myLocation = await mapController.myLocation();
              _drawNearStops();
            },
            onGeoPointClicked: (geoPoint) {
              BusStation? clickBusStation = BusDataLoader.getBusStation(
                  nearStations.entries
                      .firstWhere(
                          (mapEntry) => mapEntry.value.isEqual(geoPoint))
                      .key);
              if (clickBusStation != null) {
                Util.showSnackBar(
                  context,
                  clickBusStation.stationName.zhTw,
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
        ],
      ),
    );
  }
}

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

class _NearStopsOsmPageState extends State<NearStopsOsmPage> {
  final mapController = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
    enableTracking: true,
    unFollowUser: true,
  ));
  final Map<GeoPoint, String> nearStations = {};

  Future<void> _drawNearStops(ThemeData themeData) async {
    await mapController.removeAllCircle();
    await mapController.removeMarkers(nearStations.keys.toList());
    await mapController.drawCircle(
      CircleOSM(
        key: "1kmCircle",
        centerPoint: await mapController.myLocation(),
        radius: 1000,
        color: Colors.green.withAlpha(10),
        borderColor: Colors.green,
        strokeWidth: 3,
      ),
    );

    GeoPoint myLocation = await mapController.myLocation();
    const rad = pi / 180;
    final phi = myLocation.latitude * rad;
    final double latBoard1 = myLocation.latitude - 0.009;
    final double latBoard2 = myLocation.latitude + 0.009;
    final double cosLat = 0.009 / cos(myLocation.latitude * rad);
    final double lonBoard1 = myLocation.longitude - cosLat;
    final double lonBoard2 = myLocation.longitude + cosLat;
    nearStations.clear();
    for (BusStation busStation in BusDataLoader.busStations.values) {
      if (!(busStation.stationPosition.positionLat >= latBoard1 &&
          myLocation.latitude <= latBoard2 &&
          busStation.stationPosition.positionLon >= lonBoard1 &&
          myLocation.longitude <= lonBoard2)) {
        continue;
      }
      final double a = sqrtSin(
              (busStation.stationPosition.positionLat - myLocation.latitude) *
                  rad /
                  2) +
          sqrtCos2(phi, busStation.stationPosition.positionLat * rad) *
              sqrtSin((busStation.stationPosition.positionLon -
                      myLocation.longitude) *
                  rad /
                  2);
      final GeoPoint stationGeoPoint = busStation.stationPosition.toGeoPoint();
      if (a / (1 - a) <= 6.159e-9) {
        await mapController.addMarker(
          stationGeoPoint,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on_outlined,
              size: 48,
              color: Colors.red,
            ),
          ),
        );
        nearStations[stationGeoPoint] = busStation.stationUid;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    mapController.init();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
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
                    size: 48,
                    color: Colors.blue,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.arrow_right,
                    size: 48,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            onLocationChanged: (_) async => await _drawNearStops(themeData),
            onGeoPointClicked: (geoPoint) async {
              BusStation? clickBusStation = BusDataLoader.getBusStation(
                  nearStations.entries
                      .firstWhere((mapEntry) => mapEntry.key.isEqual(geoPoint))
                      .value);
              if (clickBusStation != null) {
                Util.showSnackBar(
                  context,
                  "Marker clicked: ${clickBusStation.stationName.zhTw}",
                );
              }
            },
            onMapIsReady: (isReady) async {
              if (isReady) {
                await mapController.enableTracking();
                await _drawNearStops(themeData);
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
                    onPressed: () async => await mapController.enableTracking(),
                    child: const Icon(Icons.my_location),
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

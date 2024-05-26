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
  final mapController = MapController.withUserPosition();

  Future<void> _drawCircle(ThemeData themeData) async {
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
                    Icons.double_arrow,
                    size: 48,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            onGeoPointClicked: (geoPoint) async {
              BusStation? clickBusStation = BusDataLoader.busStations.values
                  .cast<BusStation?>()
                  .firstWhere((busStation) =>
                      busStation!.stationPosition.positionLat ==
                          geoPoint.latitude &&
                      busStation.stationPosition.positionLon ==
                          geoPoint.longitude);
              if (clickBusStation != null) {
                Util.showSnackBar(
                  context,
                  "Marker clicked: ${clickBusStation.stationName.zhTw}",
                );
              }
            },
            onMapIsReady: (isReady) async {
              if (isReady) {
                await mapController.enableTracking(enableStopFollow: true);
                await _drawCircle(themeData);

                GeoPoint myLocation = await mapController.myLocation();
                const rad = pi / 180;
                final phi1 = myLocation.latitude * rad;
                for (BusStation busStation
                    in BusDataLoader.busStations.values) {
                  final double a = sqrtSin(
                          (busStation.stationPosition.positionLat -
                                  myLocation.latitude) *
                              rad /
                              2) +
                      sqrtCos2(phi1,
                              busStation.stationPosition.positionLat * rad) *
                          sqrtSin((busStation.stationPosition.positionLon -
                                  myLocation.longitude) *
                              rad /
                              2);
                  if (a / (1 - a) <= 6.159e-9) {
                    await mapController.addMarker(
                      busStation.stationPosition.toGeoPoint(),
                      markerIcon: const MarkerIcon(
                        icon: Icon(
                          Icons.location_on_outlined,
                          size: 48,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                }
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
                    onPressed: () async => await mapController.enableTracking(
                        enableStopFollow: true),
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

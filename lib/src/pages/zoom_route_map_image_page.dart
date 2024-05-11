import 'package:bus_app/src/tdx/loader.dart';
import 'package:flutter/material.dart';

import 'package:bus_app/src/tdx/bus_route.dart';

import 'package:bus_app/src/web_image/web_image_other.dart'
    if (dart.library.js) 'package:bus_app/src/web_image/web_image_web.dart';

class ZoomRouteMapImagePage extends MaterialPageRoute {
  final String busRouteUID;

  ZoomRouteMapImagePage(
    this.busRouteUID,
  ) : super(
            builder: (context) => ZoomRouteMapImage(
                  busRouteUID: busRouteUID,
                ));
}

class ZoomRouteMapImage extends StatefulWidget {
  final String busRouteUID;

  const ZoomRouteMapImage({super.key, required this.busRouteUID});

  @override
  State<ZoomRouteMapImage> createState() => _ZoomRouteMapImageState();
}

class _ZoomRouteMapImageState extends State<ZoomRouteMapImage> {
  int rotateQuarter = 0;
  TransformationController transformationController =
      TransformationController();
  late BoxConstraints boxConstraints;

  @override
  void dispose() {
    super.dispose();
    transformationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BusRoute busRoute = Loader.busRoutes[widget.busRouteUID]!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${busRoute.routeName.zhTw}\n${busRoute.headsign}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                boxConstraints = constraints;
                return InteractiveViewer(
                  transformationController: transformationController,
                  maxScale: 10.0,
                  child: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Colors.grey,
                    padding: const EdgeInsets.all(10),
                    child: RotatedBox(
                      quarterTurns: rotateQuarter,
                      child: RouteMapWebImage(
                        routeMapImage: busRoute.routeMapImage,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Text(
            "使用滑鼠滾輪或雙指滑動以縮放圖片",
            style: TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: FilledButton.icon(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  label: const Text(
                    "關閉",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: FilledButton.icon(
                  icon: const Icon(Icons.zoom_out_map),
                  onPressed: () {
                    transformationController.value = Matrix4.identity();
                  },
                  label: const Text(
                    "重置縮放",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: FilledButton.icon(
                  icon: const Icon(Icons.rotate_right),
                  onPressed: () => setState(() {
                    rotateQuarter++;
                    rotateQuarter %= 4;
                  }),
                  label: const Text(
                    "旋轉90度",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

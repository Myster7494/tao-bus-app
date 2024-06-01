import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:flutter/material.dart';

import '../bus_data/bus_route.dart';
import '../widgets/web_image/web_image.dart';

class RouteMapPage extends StatefulWidget {
  final String routeUid;

  const RouteMapPage({super.key, required this.routeUid});

  @override
  State<RouteMapPage> createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
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
    BusRoute busRoute = BusDataLoader.getBusRoute(widget.routeUid)!;
    return Scaffold(
      appBar: AppBar(title: const Text("路線簡圖")),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              '${busRoute.routeName.zhTw}  |  ${busRoute.headsign}',
              softWrap: true,
              maxLines: 10,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
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
                      child: WebImage(
                        webImageData: busRoute.routeMapImageData,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              "使用滑鼠滾輪或雙指滑動以縮放圖片",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
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
                padding: const EdgeInsets.all(5),
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
                padding: const EdgeInsets.all(5),
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

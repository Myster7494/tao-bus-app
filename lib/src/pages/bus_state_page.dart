import 'package:flutter/material.dart';

import 'package:bus_app/src/tdx/bus_route.dart';

import 'package:bus_app/src/web_image/web_image_other.dart'
    if (dart.library.js) 'package:bus_app/src/web_image/web_image_web.dart';

class BusStatePage {
  static MaterialPageRoute build(final BusRoute busRoute) {
    return MaterialPageRoute(
        builder: (context) => ZoomRouteMapImage(
              busRoute: busRoute,
            ));
  }
}

class ZoomRouteMapImage extends StatefulWidget {
  final BusRoute busRoute;

  const ZoomRouteMapImage({super.key, required this.busRoute});

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.busRoute.routeName.zhTw}\n${widget.busRoute.subRoutes.firstOrNull?.headsign ?? ""}'),
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
                        routeMapImage: widget.busRoute.routeMapImage,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Text("使用滑鼠滾輪或雙指滑動以縮放圖片"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("關閉"))),
              Expanded(
                  child: TextButton(
                      onPressed: () {
                        transformationController.value = Matrix4.identity();
                      },
                      child: const Text("重置縮放"))),
              Expanded(
                  child: TextButton(
                      onPressed: () => setState(() {
                            rotateQuarter++;
                            rotateQuarter %= 4;
                          }),
                      child: const Text("旋轉90度")))
            ],
          ),
        ],
      ),
    );
  }
}

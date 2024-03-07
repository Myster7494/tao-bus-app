import 'dart:math';

import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:bus_app/src/tdx/bus_routes_loader.dart';
import 'package:bus_app/src/web_image/web_image_other.dart'
    if (dart.library.js) 'package:bus_app/src/web_image/web_image_web.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TAO-Bus"),
      ),
      body: ListView.separated(
        itemCount: BusRoutesLoader.busRoutes.length,
        itemBuilder: (context, index) => ListTile(
            title: Text(BusRoutesLoader.busRoutes[index].routeName.zhTw),
            subtitle: Text(BusRoutesLoader
                    .busRoutes[index].subRoutes.firstOrNull?.headsign ??
                ""),
            trailing: PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: const Text("顯示路線簡圖"),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => RouteMapAlertDialog(
                        busRoute: BusRoutesLoader.busRoutes[index]),
                  ),
                ),
              ],
            )),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

class RouteMapAlertDialog extends StatelessWidget {
  final BusRoute busRoute;

  const RouteMapAlertDialog({super.key, required this.busRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: AlertDialog(
        title: Text(
            '${busRoute.routeName.zhTw}\n${busRoute.subRoutes.firstOrNull?.headsign ?? ""}'),
        content: RouteMapWebImage(
          routeMapImage: busRoute.routeMapImage,
        ),
        actions: <Widget>[
          TextButton(
              child: const Text("放大圖片"),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ZoomRouteMapImage(
                        busRoute: busRoute,
                      )))),
          TextButton(
            child: const Text("關閉圖片"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class ZoomRouteMapImage extends StatefulWidget {
  final BusRoute busRoute;

  const ZoomRouteMapImage({super.key, required this.busRoute});

  @override
  State<ZoomRouteMapImage> createState() => _ZoomRouteMapImageState();
}

class _ZoomRouteMapImageState extends State<ZoomRouteMapImage> {
  int rotateTime = 0;

  void rotate() {
    rotateTime++;
    rotateTime %= 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${widget.busRoute.routeName.zhTw}\n${widget.busRoute.subRoutes.firstOrNull?.headsign ?? ""}')),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => InteractiveViewer(
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  color: Colors.grey,
                  padding: const EdgeInsets.all(10),
                  child: RotatedBox(
                    quarterTurns: rotateTime,
                    child: RouteMapWebImage(
                      routeMapImage: widget.busRoute.routeMapImage,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                        rotate();
                        setState(() {});
                      },
                      child: const Text("旋轉90度")))
            ],
          )
        ],
      ),
    );
  }
}

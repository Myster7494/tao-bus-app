import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:bus_app/src/tdx/bus_routes_loader.dart';
import 'package:bus_app/src/web_image/web_image_other.dart'
    if (dart.library.js) 'package:bus_app/src/web_image/web_image_web.dart';
import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

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
        content:
            // Zoom(
            //     child:
            RouteMapWebImage(
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

class ZoomRouteMapImage extends StatelessWidget {
  final BusRoute busRoute;

  const ZoomRouteMapImage({super.key, required this.busRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${busRoute.routeName.zhTw}\n${busRoute.subRoutes.firstOrNull?.headsign ?? ""}')),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Zoom(
                initScale: 1.0,
                initTotalZoomOut: true,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Container(
                      color: Colors.grey,
                      padding: const EdgeInsets.all(10),
                      child: RouteMapWebImage(
                        routeMapImage: busRoute.routeMapImage,
                      ),
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
                  child:
                      TextButton(onPressed: () {}, child: const Text("旋轉90度")))
            ],
          )
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:bus_app/src/tdx/bus_routes_loader.dart';
import 'package:bus_app/src/web_image/web_image_other.dart'
    if (dart.library.js) 'package:bus_app/src/web_image/web_image_web.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TAO-Bus"),
      ),
      body: const HomePageBody(),
    );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final TextEditingController textEditingController = TextEditingController();
  List<BusRoute> busRoutes = BusRoutesLoader.busRoutes;
  String inputText = "";

  @override
  void initState() {
    super.initState();

    textEditingController.addListener(() => setState(() => busRoutes =
        BusRoutesLoader.busRoutes
           .where((busRoute) =>
                busRoute.routeName.zhTw.contains(textEditingController.text))
           .toList()));
  }

  void search(String input){
    setState(() { busRoutes = 
    BusRoutesLoader.busRoutes                         
    .where((busRoute) =>
                busRoute.routeName.zhTw.contains(input)).toList();});
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
	//onChanged:(value)=>search(value),
          controller: textEditingController,
          decoration: const InputDecoration(hintText: "搜尋路線名稱"),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: busRoutes.length,
            itemBuilder: (context, index) => ListTile(
                title: Text(busRoutes[index].routeName.zhTw),
                subtitle: Text(busRoutes[index].subRoutes.firstOrNull?.headsign ??
                    ""),
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: const Text("顯示路線簡圖"),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => RouteMapAlertDialog(
                            busRoute: busRoutes[index]),
                      ),
                    ),
                  ],
                )),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ],
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
              '${widget.busRoute.routeName.zhTw}\n${widget.busRoute.subRoutes.firstOrNull?.headsign ?? ""}')),
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
          )
        ],
      ),
    );
  }
}

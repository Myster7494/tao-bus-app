import 'package:bus_app/src/pages/zoom_route_map_image_page.dart';
import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:bus_app/src/tdx/bus_routes_loader.dart';
import 'package:bus_app/src/web_image/web_image_other.dart'
    if (dart.library.js) 'package:bus_app/src/web_image/web_image_web.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

  void search(String input) {
    setState(() {
      busRoutes = BusRoutesLoader.busRoutes
          .where((busRoute) => busRoute.routeName.zhTw.contains(input))
          .toList();
    });
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
                subtitle: Text(
                    busRoutes[index].subRoutes.firstOrNull?.headsign ?? ""),
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: const Text("顯示路線簡圖"),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) =>
                            RouteMapAlertDialog(busRoute: busRoutes[index]),
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
              onPressed: () => Navigator.of(context)
                  .push(ZoomRouteMapImagePage.build(busRoute))),
          TextButton(
            child: const Text("關閉圖片"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

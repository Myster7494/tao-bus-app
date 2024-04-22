import 'package:bus_app/src/pages/bus_state_page.dart';
import 'package:bus_app/src/pages/zoom_route_map_image_page.dart';
import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:bus_app/src/tdx/loader.dart';
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
  List<BusRoute> busRoutes = Loader.busRoutes.values.toList()
    ..sort((a, b) => a.routeName.zhTw.compareTo(b.routeName.zhTw));

  void search(String input) {}

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
          controller: textEditingController,
          decoration: const InputDecoration(hintText: "搜尋路線名稱"),
          onChanged: (input) => setState(() => busRoutes = Loader
              .busRoutes.values
              .toList()
              .where((busRoute) => busRoute.routeName.zhTw.contains(input))
              .toList()
            ..sort((a, b) => a.routeName.zhTw.compareTo(b.routeName.zhTw))),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: busRoutes.length,
            itemBuilder: (context, index) => ListTile(
                title: Text(busRoutes[index].routeName.zhTw),
                subtitle: Text(busRoutes[index].headsign),
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                        child: const Text("顯示路線簡圖"),
                        onTap: () => Navigator.of(context).push(
                            ZoomRouteMapImagePage(busRoutes[index].routeUid))),
                    PopupMenuItem(
                        child: const Text("顯示公車動態"),
                        onTap: () => Navigator.of(context)
                            .push(BusStatePage(busRoutes[index].routeUid))),
                  ],
                )),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ],
    );
  }
}

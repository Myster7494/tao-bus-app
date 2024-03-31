import 'package:bus_app/src/pages/bus_state_page.dart';
import 'package:bus_app/src/pages/zoom_route_map_image_page.dart';
import 'package:bus_app/src/tdx/bus_route.dart';
import 'package:bus_app/src/tdx/bus_routes_loader.dart';
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
                        onTap: () => Navigator.of(context)
                            .push(ZoomRouteMapImagePage(busRoutes[index]))),
                    PopupMenuItem(
                        child: const Text("顯示公車動態"),
                        onTap: () => Navigator.of(context)
                            .push(BusStatePage(busRoutes[index]))),
                  ],
                )),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ],
    );
  }
}

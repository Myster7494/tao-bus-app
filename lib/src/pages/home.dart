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
        title: const Text("桃園公車-自主學習"),
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

int sortRoutes(BusRoute a, BusRoute b) {
  if (a.routeName.zhTw.startsWith(RegExp(r'[^0-9]')) ||
      b.routeName.zhTw.startsWith(RegExp(r'[^0-9]'))) {
    return a.routeName.zhTw.compareTo(b.routeName.zhTw);
  }
  String aNum = a.routeName.zhTw.replaceAll(RegExp(r'[^0-9]'), '');
  String bNum = b.routeName.zhTw.replaceAll(RegExp(r'[^0-9]'), '');
  if (aNum == bNum) {
    return a.routeName.zhTw.compareTo(b.routeName.zhTw);
  }
  return aNum.compareTo(bNum);
}

class _HomePageBodyState extends State<HomePageBody> {
  final TextEditingController textEditingController = TextEditingController();
  List<BusRoute> busRoutes = Loader.busRoutes.values.toList()
    ..sort((a, b) => sortRoutes(a, b));

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(25),
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            child: TextField(
              controller: textEditingController,
              decoration:
                  const InputDecoration(hintText: "搜尋路線名稱", isDense: true),
              onChanged: (input) => setState(
                () => busRoutes = Loader.busRoutes.values
                    .toList()
                    .where((busRoute) => input.split(' ').every((element) =>
                        busRoute.routeName.zhTw.contains(element) ||
                        busRoute.headsign.contains(element)))
                    .toList()
                  ..sort((a, b) => sortRoutes(a, b)),
              ),
            )),
        Expanded(
          child: Builder(
            builder: (context) {
              if (busRoutes.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off,
                          size: 100,
                          color: Theme.of(context).colorScheme.primary),
                      const Text(
                        "找不到符合的路線",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                itemCount: busRoutes.length,
                itemBuilder: (context, index) => ListTile(
                    title: Text(
                      busRoutes[index].routeName.zhTw,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      busRoutes[index].headsign,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                            child: const Text("顯示路線簡圖"),
                            onTap: () => Navigator.of(context).push(
                                ZoomRouteMapImagePage(
                                    busRoutes[index].routeUid))),
                        PopupMenuItem(
                            child: const Text("顯示公車動態"),
                            onTap: () => Navigator.of(context)
                                .push(BusStatePage(busRoutes[index].routeUid))),
                      ],
                    )),
                separatorBuilder: (context, index) => const Divider(height: 5),
              );
            },
          ),
        ),
      ],
    );
  }
}

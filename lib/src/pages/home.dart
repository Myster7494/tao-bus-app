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

class _HomePageBodyState extends State<HomePageBody> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController =
      ScrollController(keepScrollOffset: false);
  late List<BusRoute> busRoutes;

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

  void modifyRoutes() {
    setState(() => busRoutes = Loader.busRoutes.values
        .toList()
        .where((busRoute) => textEditingController.text.split(' ').every(
            (element) =>
                busRoute.routeName.zhTw.contains(element) ||
                busRoute.headsign.contains(element)))
        .toList()
      ..sort((a, b) => sortRoutes(a, b)));
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  @override
  void initState() {
    super.initState();
    modifyRoutes();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: busRoutes.isEmpty
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: TextField(
                    onChanged: (text) => modifyRoutes(),
                    style: TextStyle(
                        color: busRoutes.isEmpty
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onSurface),
                    cursorColor: busRoutes.isEmpty
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).unselectedWidgetColor,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: "搜尋路線名稱",
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: busRoutes.isEmpty
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).unselectedWidgetColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: busRoutes.isEmpty
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: "清除搜尋",
                icon: const Icon(Icons.clear),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  if (textEditingController.text.isEmpty) {
                    return;
                  }
                  textEditingController.clear();
                  modifyRoutes();
                },
              ),
            ],
          ),
        ),
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
                controller: scrollController,
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
                      tooltip: "顯示功能選單",
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Center(
                              child: Text(
                                "顯示路線簡圖",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            onTap: () => Navigator.of(context).push(
                                ZoomRouteMapImagePage(
                                    busRoutes[index].routeUid))),
                        PopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Center(
                              child: Text(
                                "顯示公車動態",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
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

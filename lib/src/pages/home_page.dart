import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:bus_app/src/widgets/show_bus_state_btn.dart';
import 'package:bus_app/src/widgets/theme_provider.dart';
import 'package:flutter/material.dart';

import '../bus_data/bus_route.dart';
import '../util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController =
      ScrollController(keepScrollOffset: false);
  late List<BusRoute> busRoutes;

  void modifyRoutes() {
    setState(() => busRoutes = BusDataLoader.getAllBusRoutesList()
        .where((busRoute) => textEditingController.text.split(' ').every(
            (element) =>
                busRoute.routeName.zhTw.contains(element) ||
                busRoute.headsign.contains(element)))
        .toList()
      ..sort((a, b) => Util.sortRoutes(a, b)));
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
    return ThemeProvider(
      builder: (BuildContext context, ThemeData themeData) => Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeData.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(25),
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: busRoutes.isEmpty
                      ? themeData.colorScheme.error
                      : themeData.colorScheme.primary,
                ),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                    child: TextField(
                      onChanged: (text) => modifyRoutes(),
                      style: TextStyle(
                          color: busRoutes.isEmpty
                              ? themeData.colorScheme.error
                              : themeData.colorScheme.onSurface),
                      cursorColor: busRoutes.isEmpty
                          ? themeData.colorScheme.error
                          : themeData.unselectedWidgetColor,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "搜尋路線名稱",
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: busRoutes.isEmpty
                                  ? themeData.colorScheme.error
                                  : themeData.unselectedWidgetColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: busRoutes.isEmpty
                                  ? themeData.colorScheme.error
                                  : themeData.colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: "清除搜尋",
                  icon: const Icon(Icons.clear),
                  color: themeData.colorScheme.primary,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 100, color: themeData.colorScheme.primary),
                        const SizedBox(height: 10),
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
                      trailing:
                          ShowBusStateBtn(routeUid: busRoutes[index].routeUid)),
                  separatorBuilder: (context, index) =>
                      const Divider(height: 5),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../util.dart';
import 'favorite_stops_page.dart';
import 'home_page.dart';
import 'osm_map_page.dart';
import 'settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("桃園公車-自主學習"),
        actions: [
          FilledButton(
              onPressed: () async => await Util.requestGpsPermission(),
              child: const Text('更新GPS狀態'))
        ],
      ),
      body: switch (selectedIndex) {
        0 => const HomePage(),
        1 => const FavoriteStopsPage(),
        2 => const OsmMapPage(),
        3 => const SettingsPage(),
        _ => throw UnsupportedError('Invalid index: $selectedIndex'),
      },
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首頁',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: '收藏站牌',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: '站牌地圖',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}

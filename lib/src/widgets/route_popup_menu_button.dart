import 'package:flutter/material.dart';

import '../pages/bus_state_page.dart';
import '../pages/route_map_img_page.dart';

class RoutePopupMenuButton extends StatelessWidget {
  final String routeUid;

  const RoutePopupMenuButton({super.key, required this.routeUid});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
            MaterialPageRoute(
              builder: (context) => RouteMapPage(routeUid: routeUid),
            ),
          ),
        ),
        PopupMenuItem(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: const Center(
            child: Text(
              "顯示公車動態",
              style: TextStyle(fontSize: 16),
            ),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BusStatePage(
                routeUid: routeUid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

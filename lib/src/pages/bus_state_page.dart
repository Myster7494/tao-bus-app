import 'package:flutter/material.dart';

import 'package:bus_app/src/tdx/bus_route.dart';

import 'package:bus_app/src/web_image/web_image_other.dart'
    if (dart.library.js) 'package:bus_app/src/web_image/web_image_web.dart';

class BusStatePage extends MaterialPageRoute {
  final BusRoute busRoute;

  BusStatePage(
    this.busRoute,
  ) : super(
            builder: (context) => BusStatePageWidget(
                  busRoute: busRoute,
                ));
}

class BusStatePageWidget extends StatefulWidget {
  final BusRoute busRoute;

  const BusStatePageWidget({super.key, required this.busRoute});

  @override
  State<BusStatePageWidget> createState() => _BusStatePageWidgetState();
}

class _BusStatePageWidgetState extends State<BusStatePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.busRoute.routeName.zhTw}\n${widget.busRoute.subRoutes.firstOrNull?.headsign ?? ""}'),
      ),
      body: ListView.builder(
        itemCount: widget.busRoute.subRoutes[0].stops.length,
        itemBuilder: (context, index) {
          final stops = widget.busRoute.subRoutes[0].stops;
          return ListTile(
            title: Text(widget.busRoute.subRoute[0].headsign),
            subtitle: Text(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../pages/bus_state_page.dart';

class ShowBusStateBtn extends StatelessWidget {
  final String routeUid;

  const ShowBusStateBtn({super.key, required this.routeUid});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BusStatePage(routeUid: routeUid),
        ),
      ),
      style: FilledButton.styleFrom(padding: const EdgeInsets.all(10)),
      child: const Text('顯示公車動態', style: TextStyle(fontSize: 16)),
    );
  }
}

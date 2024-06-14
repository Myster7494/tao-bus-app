import 'package:flutter/material.dart';

class ShowMapButton extends StatelessWidget {
  final ValueNotifier<bool> showMap;

  const ShowMapButton({super.key, required this.showMap});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(padding: const EdgeInsets.all(10)),
      onPressed: () => showMap.value = !showMap.value,
      child: ValueListenableBuilder(
        valueListenable: showMap,
        builder: (BuildContext context, bool value, Widget? child) =>
            Text(value ? "隱藏地圖" : "顯示地圖", style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

import 'package:bus_app/src/bus_data/estimated_time.dart';
import 'package:bus_app/src/widgets/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bus_data/bus_data_loader.dart';

class EstimatedTimeText extends StatelessWidget {
  final String routeUid;
  final int direction;
  final String stopUid;
  final int? stopSequence;
  final bool? showPlateNumb;

  const EstimatedTimeText(
      {super.key,
      required this.routeUid,
      required this.direction,
      required this.stopUid,
      this.stopSequence,
      this.showPlateNumb});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, theme) {
      EstimatedTimeData estimatedTimeData = BusDataLoader.allEstimatedTime
              .getEstimatedTimeData(routeUid, direction, stopUid: stopUid) ??
          BusDataLoader.allEstimatedTime.getEstimatedTimeData(
              routeUid, direction,
              stopSequence: stopSequence) ??
          EstimatedTimeData.noData();
      if (estimatedTimeData.estimatedTime == null ||
          estimatedTimeData.estimatedTime! < 0) {
        if (estimatedTimeData.nextBusTime != null &&
            (showPlateNumb ?? estimatedTimeData.isClosestStop)) {
          return Text(
            '尚未發車\n${DateFormat.Hm().format(estimatedTimeData.nextBusTime!.toLocal())}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          );
        }
        return Text(
          switch (estimatedTimeData.stopStatus) {
            1 => estimatedTimeData.nextBusTime != null
                ? DateFormat.Hm()
                    .format(estimatedTimeData.nextBusTime!.toLocal())
                : '今日未營運',
            2 => '交管不停靠',
            3 => '末班車已過',
            4 => '今日未營運',
            999 => '無資料',
            _ => '未知狀態',
          },
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        );
      }
      String showText = "";
      Color? color;
      double fontSize = 18;
      if (showPlateNumb ?? estimatedTimeData.isClosestStop) {
        if (estimatedTimeData.plateNumb == '') {
          showText = '尚未發車\n';
        } else {
          showText = '${estimatedTimeData.plateNumb}\n';
        }
        fontSize = 16;
      }
      int estimatedMinutes = estimatedTimeData.estimatedTime! ~/ 60;
      if (estimatedMinutes <= 1) {
        showText += "進站中";
        color = Colors.red;
      } else {
        showText += "$estimatedMinutes 分";
        if (estimatedMinutes <= 3) {
          color = Colors.orange;
        }
      }
      return Text(
        showText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
        ),
      );
    });
  }
}

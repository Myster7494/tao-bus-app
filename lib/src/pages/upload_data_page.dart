import 'dart:convert';

import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util.dart';

class UploadDataPage extends StatefulWidget {
  const UploadDataPage({super.key});

  @override
  State<StatefulWidget> createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          childrenPadding: const EdgeInsets.all(20),
          leading: const Icon(CupertinoIcons.clock),
          title: const Text('預估到站時間資料'),
          children: [
            ListTile(
              title: FilledButton(
                onPressed: () async {
                  if (await BusDataLoader.loadEstimatedTime(
                      LoadDataSourceType.tdx)) {
                    setState(() {});
                  } else if (context.mounted) {
                    Util.showSnackBar(context, "無法從TDX更新預估到站時間資料");
                  }
                },
                child: const Text('從TDX更新預估到站時間資料'),
              ),
            ),
            ListTile(
              title: FilledButton(
                onPressed: () async {
                  if (await BusDataLoader.loadEstimatedTime(
                      LoadDataSourceType.github)) {
                    setState(() {});
                  } else if (context.mounted) {
                    Util.showSnackBar(context, "無法從Github更新預估到站時間資料");
                  }
                },
                child: const Text('從Github更新預估到站時間資料'),
              ),
            ),
            ListTile(
              title: FilledButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    await BusDataLoader.loadEstimatedTime(
                        LoadDataSourceType.string,
                        jsonString:
                            utf8.decode(result.files.single.bytes!.toList()));
                    setState(() {});
                  }
                },
                child: const Text('上傳預估到站時間資料'),
              ),
            ),
            ListTile(
              title: FilledButton(
                onPressed: () async {
                  Uri url = Uri.parse(Util.tdxEstimatedTimeUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else if (context.mounted) {
                    Util.showSnackBar(context, "無法開啟預估到站時間資料網頁");
                  }
                },
                child: const Text('開啟預估到站時間資料網頁'),
              ),
            ),
            ListTile(
              title: Text(
                  "資料時間：${DateFormat('yyyy-MM-dd').add_Hms().format(RecordData.allEstimatedTime.lastUpdateTime.toLocal()).toString()}"),
            ),
          ],
        ),
        ExpansionTile(
          childrenPadding: const EdgeInsets.all(20),
          leading: const Icon(CupertinoIcons.bus),
          title: const Text('公車定時位置資料'),
          children: [
            ListTile(
              title: FilledButton(
                onPressed: () async {
                  if (await BusDataLoader.loadRealTimeBuses(
                      LoadDataSourceType.tdx)) {
                    setState(() {});
                  } else if (context.mounted) {
                    Util.showSnackBar(context, "無法從TDX更新公車定時位置資料");
                  }
                },
                child: const Text('從TDX更新公車定時位置資料'),
              ),
            ),
            ListTile(
              title: FilledButton(
                onPressed: () async {
                  if (await BusDataLoader.loadRealTimeBuses(
                      LoadDataSourceType.github)) {
                    setState(() {});
                  } else if (context.mounted) {
                    Util.showSnackBar(context, "無法從Github更新公車定時位置資料");
                  }
                },
                child: const Text('從Github更新公車定時位置資料'),
              ),
            ),
            ListTile(
              title: FilledButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    await BusDataLoader.loadRealTimeBuses(
                        LoadDataSourceType.string,
                        jsonString:
                            utf8.decode(result.files.single.bytes!.toList()));
                    setState(() {});
                  }
                },
                child: const Text('上傳公車定時位置資料'),
              ),
            ),
            ListTile(
              title: FilledButton(
                onPressed: () async {
                  Uri url = Uri.parse(Util.tdxRealTimeBusUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else if (context.mounted) {
                    Util.showSnackBar(context, "無法開啟公車定時位置資料網頁");
                  }
                },
                child: const Text('開啟公車定時位置資料網頁'),
              ),
            ),
            ListTile(
              title: Text(
                  "資料時間：${DateFormat('yyyy-MM-dd').add_Hms().format(RecordData.realTimeBuses.lastUpdateTime.toLocal()).toString()}"),
            ),
          ],
        ),
      ],
    );
  }
}

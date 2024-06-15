import 'dart:convert';

import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../util.dart';

class UploadDataPage extends StatefulWidget {
  const UploadDataPage({super.key});

  @override
  State<StatefulWidget> createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.cloud_upload, size: 100),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    await BusDataLoader.loadEstimatedTime(
                        jsonString:
                            utf8.decode(result.files.single.bytes!.toList()));
                    setState(() {});
                  }
                },
                child: const Text('上傳預估到站時間'),
              ),
              const SizedBox(height: 10),
              Text(DateFormat('yyyy-MM-dd')
                  .add_Hms()
                  .format(RecordData.allEstimatedTime.lastUpdateTime.toLocal())
                  .toString()),
            ],
          ),
          const SizedBox(width: 30),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.cloud_upload, size: 100),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    await BusDataLoader.loadRealTimeBuses(
                        jsonString:
                            utf8.decode(result.files.single.bytes!.toList()));
                    setState(() {});
                  }
                },
                child: const Text('上傳公車定時位置'),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    await BusDataLoader.loadRealTimeBuses(
                        jsonString:
                            utf8.decode(result.files.single.bytes!.toList()));
                    setState(() {});
                  }
                },
                child: const Text('上傳公車定時位置'),
              ),
              const SizedBox(height: 10),
              Text(DateFormat('yyyy-MM-dd')
                  .add_Hms()
                  .format(RecordData.realTimeBuses.lastUpdateTime.toLocal())
                  .toString()),
            ],
          ),
        ],
      ),
    );
  }
}

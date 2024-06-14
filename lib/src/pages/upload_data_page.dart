import 'dart:convert';

import 'package:bus_app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../storage/last_update_enum.dart';

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
            children: [
              const Icon(CupertinoIcons.cloud_upload, size: 100),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    localStorage.estimatedTimeData =
                        utf8.decode(result.files.single.bytes!.toList());
                  }
                },
                child: const Text('上傳預估到站時間'),
              ),
              const SizedBox(height: 10),
              Text(localStorage.lastUpdate[LastUpdateType.estimatedTimeData]
                      ?.toLocal()
                      .toString() ??
                  "尚未上傳"),
            ],
          ),
          const SizedBox(width: 30),
          Column(
            children: [
              const Icon(CupertinoIcons.cloud_upload, size: 100),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    localStorage.estimatedTimeData =
                        utf8.decode(result.files.single.bytes!.toList());
                  }
                },
                child: const Text('上傳公車定時位置'),
              ),
              const SizedBox(height: 10),
              Text(localStorage.lastUpdate[LastUpdateType.realTimeBusesData]
                      ?.toLocal()
                      .toString() ??
                  "尚未上傳"),
            ],
          ),
        ],
      ),
    );
  }
}

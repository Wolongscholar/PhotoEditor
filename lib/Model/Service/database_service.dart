import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:photo_editor/Model/draft.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

// Hive DB to save drafts

class DataBaseService extends ChangeNotifier {
  static Future<void> setUp() async {
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(DraftAdapter());
  }
}

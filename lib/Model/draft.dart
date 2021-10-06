import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'draft.g.dart';

// Draft Model

@HiveType(typeId: 0)
class Draft {
  // @override
  // int get typeId => 0;

  @HiveField(0)
  String path; // relative path only
  Draft(this.path);
}

DateFormat dateFormat = DateFormat("yyMMddHHmmssSSS");

String nameForNewImage() {
  return dateFormat.format(DateTime.now()) + ".jpg";
}

Future<String> absolutePathForImage(String name) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  final path = appDocPath + "/" + name;
  return path;
}

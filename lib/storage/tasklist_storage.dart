// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import '../models/my_task_list.dart';

// class TasklistStorage {
//   static const _filename = 'tasklists.json';

//   Future<File> getFile() async {
//     final dir = await getApplicationSupportDirectory();
//     return File('${dir.path}/$_filename');
//   }

//   Future<Map<String, MyTaskList>> readAll() async {
//     final file = await getFile();
//     if (!await file.exists()) return {};

//     final content = await file.readAsString();
//     final Map<String, dynamic> jsonMap = jsonDecode(content);
//     return jsonMap.map(
//       (key, value) => MapEntry(key, MyTaskList.fromJson(value)),
//     );
//   }

//   Future<void> writeAll(Map<String, MyTaskList> tasklists) async {
//     final file = await getFile();
//     final jsonMap = tasklists.map(
//       (key, value) => MapEntry(key, value.toJson()),
//     );
//     await file.writeAsString(jsonEncode(jsonMap));
//   }
// }

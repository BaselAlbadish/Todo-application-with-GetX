import 'dart:convert';
import 'package:get/get.dart';
import '../../../core/utils/keys.dart';
import '../../models/task.dart';
import '../../services/storage/services.dart';

class TaskProvider {
  final StorageService _storage = Get.find<StorageService>();


  List<Task> readTask() {
    var tasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString())
        .forEach((e) => tasks.add(Task.fromJson(e)));
    return tasks;
  }

  void writeTasks(List<Task> tasks) {
    // it will use toJson method {~~maybe}
    _storage.write(taskKey, jsonEncode(tasks));
  }
}

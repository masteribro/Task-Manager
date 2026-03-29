import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../models/task_model.dart';

abstract class TaskDataSource {
  Future<void> init();
  List<TaskModel> getAllTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  TaskModel? getTaskById(String taskId);
  Future<void> clearAllTasks();
}

class TaskLocalDataSource implements TaskDataSource {
  late Box<TaskModel> _taskBox;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (!_initialized) {
      _taskBox = await Hive.openBox<TaskModel>(AppConstants.taskBoxName);
      _initialized = true;
    }
  }

  @override
  List<TaskModel> getAllTasks() {
    if (!_initialized) {
      throw Exception('TaskLocalDataSource not initialized. Call init() first.');
    }
    return _taskBox.values.toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await init();
    await _taskBox.put(task.id, task);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await init();
    await _taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await init();
    await _taskBox.delete(taskId);
  }

  @override
  TaskModel? getTaskById(String taskId) {
    if (!_initialized) {
      return null;
    }
    return _taskBox.get(taskId);
  }

  @override
  Future<void> clearAllTasks() async {
    await init();
    await _taskBox.clear();
  }
}

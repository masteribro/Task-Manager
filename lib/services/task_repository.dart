import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskRepository {
  static const String taskBoxName = 'tasks';
  late Box<Task> _taskBox;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _taskBox = await Hive.openBox<Task>(taskBoxName);
      _initialized = true;
    }
  }

  List<Task> getAllTasks() {
    if (!_initialized) {
      throw Exception('TaskRepository not initialized. Call init() first.');
    }
    return _taskBox.values.toList();
  }

  Future<void> addTask(Task task) async {
    await init();
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await init();
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String taskId) async {
    await init();
    await _taskBox.delete(taskId);
  }

  Task? getTaskById(String taskId) {
    if (!_initialized) {
      return null;
    }
    return _taskBox.get(taskId);
  }

  List<Task> searchTasks(String query) {
    final tasks = getAllTasks();
    if (query.isEmpty) return tasks;

    return tasks
        .where((task) =>
            task.title.toLowerCase().contains(query.toLowerCase()) ||
            task.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Task> getCompletedTasks() {
    return getAllTasks().where((task) => task.isCompleted).toList();
  }

  List<Task> getPendingTasks() {
    return getAllTasks().where((task) => !task.isCompleted).toList();
  }

  Future<void> clearAllTasks() async {
    await init();
    await _taskBox.clear();
  }
}

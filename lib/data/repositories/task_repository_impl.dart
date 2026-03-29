import '../models/task_model.dart';
import '../datasources/task_local_datasource.dart';

abstract class TaskRepository {
  Future<void> init();
  List<TaskModel> getAllTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  TaskModel? getTaskById(String taskId);
  List<TaskModel> searchTasks(String query);
  List<TaskModel> getCompletedTasks();
  List<TaskModel> getPendingTasks();
  Future<void> clearAllTasks();
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource _localDataSource;

  TaskRepositoryImpl({required TaskDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<void> init() async {
    await _localDataSource.init();
  }

  @override
  List<TaskModel> getAllTasks() {
    return _localDataSource.getAllTasks();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await _localDataSource.addTask(task);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _localDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _localDataSource.deleteTask(taskId);
  }

  @override
  TaskModel? getTaskById(String taskId) {
    return _localDataSource.getTaskById(taskId);
  }

  @override
  List<TaskModel> searchTasks(String query) {
    final tasks = getAllTasks();
    if (query.isEmpty) return tasks;

    return tasks
        .where((task) =>
            task.title.toLowerCase().contains(query.toLowerCase()) ||
            task.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  List<TaskModel> getCompletedTasks() {
    return getAllTasks().where((task) => task.isCompleted).toList();
  }

  @override
  List<TaskModel> getPendingTasks() {
    return getAllTasks().where((task) => !task.isCompleted).toList();
  }

  @override
  Future<void> clearAllTasks() async {
    await _localDataSource.clearAllTasks();
  }
}

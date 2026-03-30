import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../core/strings/app_strings.dart';
import '../../data/datasources/task_local_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/models/task_model.dart';

final taskLocalDataSourceProvider = Provider<TaskDataSource>((ref) {
  return TaskLocalDataSource();
});

/// Asynchronously initializes the repository.
/// Ensures underlying storage (Hive box, etc.) is ready before use.
final taskRepositoryProvider = FutureProvider<TaskRepository>((ref) async {
  final dataSource = ref.watch(taskLocalDataSourceProvider);
  final repository = TaskRepositoryImpl(localDataSource: dataSource);
  await repository.init(); // Important: initialize storage before usage
  return repository;
});

/// Main state provider holding the list of tasks.
/// Uses StateNotifier for better control over state mutations.
final tasksProvider =
StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier(ref);
});

/// Holds the current search query entered by the user.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Filters tasks based on search query (title or description).
/// Performs case-insensitive matching.
final filteredTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) {
    return tasks; // No filtering if query is empty
  }

  return tasks
      .where((task) =>
  task.title.toLowerCase().contains(query.toLowerCase()) ||
      task.description.toLowerCase().contains(query.toLowerCase()))
      .toList();
});

/// Returns only completed tasks.
final completedTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.isCompleted).toList();
});

/// Returns only pending (not completed) tasks.
final pendingTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => !task.isCompleted).toList();
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  final Ref ref;

  /// Repository is initialized asynchronously, so we store it later.
  late TaskRepository repository;

  /// Tracks whether repository initialization is complete.
  bool initialized = false;

// Kick off async initialization immediately
  TaskNotifier(this.ref) : super([]) {
    initialize();
  }

  /// Initializes the repository and loads tasks.
  /// This ensures data is ready before any operations are performed.
  Future<void> initialize() async {
    try {
      repository = await ref.watch(taskRepositoryProvider.future);
      initialized = true;
      loadTasks();
    } catch (e) {
      print('${AppStrings.errorInitializingNotifier}$e');
    }
  }

  /// Loads all tasks from repository into state.
  /// Guarded to prevent execution before initialization completes.
  void loadTasks() {
    if (!initialized) return;
    final tasks = repository.getAllTasks();
    state = tasks;
  }

  /// Adds a new task, ensuring initialization is complete first.
  Future<void> addTask(TaskModel task) async {
    if (!initialized) await initialize();
    await repository.addTask(task);
    loadTasks();
  }

  /// Updates an existing task and refreshes state.
  Future<void> updateTask(TaskModel task) async {
    if (!initialized) await initialize();
    await repository.updateTask(task);
    loadTasks();
  }

  /// Toggles the completion status of a task.
  /// Fetches task by ID, flips `isCompleted`, then persists update.
  Future<void> toggleTaskCompletion(String taskId) async {
    if (!initialized) await initialize();
    final task = repository.getTaskById(taskId);
    if (task != null) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await repository.updateTask(updatedTask);
      loadTasks();
    }
  }

  /// Deletes a task and refreshes state.
  Future<void> deleteTask(String taskId) async {
    if (!initialized) await initialize();
    await repository.deleteTask(taskId);
    loadTasks();
  }
}
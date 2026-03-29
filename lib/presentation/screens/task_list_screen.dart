import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/search_bar_widget.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasksProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appBarTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          SearchBarWidget(
            searchQuery: searchQuery,
            onSearchChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            onClearSearch: () {
              ref.read(searchQueryProvider.notifier).state = '';
            },
          ),
          Expanded(
            child: tasks.isEmpty
                ? EmptyStateWidget(
                    message: searchQuery.isNotEmpty
                        ? AppStrings.noTasksFoundMessage
                        : AppStrings.noTasksYetMessage,
                    icon: searchQuery.isNotEmpty
                        ? Icons.search_off
                        : Icons.assignment_ind_outlined,
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskTile(
                        task: task,
                        onEdit: () => showTaskFormDialog(
                          context,
                          ref,
                          task: task,
                        ),
                        onDelete: () =>
                            showDeleteConfirmation(context, ref, task.id),
                        onCompletedChanged: (_) {
                          ref
                              .read(tasksProvider.notifier)
                              .toggleTaskCompletion(task.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTaskFormDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void showTaskFormDialog(
    BuildContext context,
    WidgetRef ref, {
    TaskModel? task,
  }) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        task: task,
        onSubmit: (newTask) {
          if (task != null) {
            ref.read(tasksProvider.notifier).updateTask(newTask);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.taskUpdatedSuccessfully)),
            );
          } else {
            ref.read(tasksProvider.notifier).addTask(newTask);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.taskCreatedSuccessfully)),
            );
          }
        },
      ),
    );
  }

  void showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    String taskId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteTaskTitle),
        content: const Text(AppStrings.deleteTaskConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancelButtonText),
          ),
          TextButton(
            onPressed: () {
              ref.read(tasksProvider.notifier).deleteTask(taskId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.taskDeletedSuccessfully)),
              );
            },
            child: const Text(AppStrings.deleteButtonText,
                style: TextStyle(color: AppColors.delete)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(bool?) onCompletedChanged;

  const TaskTile({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onCompletedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: onCompletedChanged,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
            task.isCompleted ? TextDecoration.lineThrough : null,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          task.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
              color: AppColors.primary,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              color: AppColors.delete,
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}

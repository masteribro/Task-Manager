import 'package:flutter/material.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';

class TaskFormDialog extends StatefulWidget {
  final TaskModel? task;
  final Function(TaskModel) onSubmit;

  const TaskFormDialog({
    super.key,
    this.task,
    required this.onSubmit,
  }) ;

  @override
  State<TaskFormDialog> createState() => TaskFormDialogState();
}

class TaskFormDialogState extends State<TaskFormDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;

    final isEditing = widget.task != null;

    if (isEditing) {
      final updatedTask = widget.task!.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
      );
      widget.onSubmit(updatedTask);
    } else {
      final newTask = TaskModel(
        id: DateTime.now().toString(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        createdAt: DateTime.now(),
      );
      widget.onSubmit(newTask);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? AppStrings.editTaskTitle : AppStrings.createNewTaskTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: AppStrings.taskTitleLabel,
                  hintText: AppStrings.taskTitleHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: const Icon(Icons.title),
                ),
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return AppStrings.taskTitleEmptyError;
              }
              return null;
            },
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: AppStrings.descriptionLabel,
                  hintText: AppStrings.descriptionHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(AppStrings.cancelButtonText),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: submit,
                    child: Text(isEditing
                        ? AppStrings.updateTaskButtonText
                        : AppStrings.addTaskButtonText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

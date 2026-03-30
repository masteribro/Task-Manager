# task_manager

A clean, efficient Flutter task management application demonstrating modern state management with Riverpod and local data persistence using Hive.

## Features

- **Task List Display**: View all tasks with title, description, and completion status
- **Add/Edit Tasks**: Create new tasks or modify existing ones with a modal form
- **Task Completion Toggle**: Mark tasks as complete with a single tap
- **Delete Tasks**: Remove tasks with a dismissible swipe gesture and confirmation dialog
- **Search Functionality**: Filter tasks by title or description in real-time
- **Data Persistence**: All tasks persist across app sessions using Hive
- **Empty State**: Helpful messaging when no tasks exist
- **Responsive UI**: Clean Material Design interface that works seamlessly on different screen sizes

## Architecture

### Clean Architecture Pattern

The application follows clean architecture principles with clear separation of concerns:

```
lib/
├── main.dart           # Application entry point
├── models/             # Domain models and entities (Task)
├── services/           # Business logic layer (TaskRepository)
├── providers/          # State management with Riverpod
├── screens/            # Full-page widgets and views
└── widgets/            # Reusable UI components and widgets
```

**Models Layer** - `lib/models/task.dart`
- Hive-annotated `Task` model for local storage
- Immutable design with `copyWith` for type safety
- Represents core domain entity with all business logic

**Services Layer** - `lib/services/task_repository.dart`
- `TaskRepository` handles all persistence operations
- Abstracts Hive implementation details
- Provides clean interface for CRUD operations and filtering
- Ensures single responsibility principle

**State Management** - `lib/providers/`
- `taskProvider`: Main task list state with StateNotifier

**Presentation Layer** (`lib/screens/` & `lib/widgets/`)
- `TaskListScreen`: Main screen with search and task list
- `TaskTile`: Individual task display with actions
- `TaskFormDialog`: Modal for creating/editing tasks
- `EmptyState`: Placeholder for empty states

## State Management Approach

**Why Riverpod?**
- Type-safe dependency injection
- Reactive updates without listeners
- Easy testing and predictable state flow
- Better performance with automatic caching
- No context needed for providers

**Key Providers:**
- `taskRepositoryProvider`: Singleton repository instance
- `tasksProvider`: Main task list state (StateNotifier)
- `searchQueryProvider`: Current search query
- `filteredTasksProvider`: Computed tasks based on search
- `completedTasksProvider`: View of completed tasks
- `pendingTasksProvider`: View of pending tasks

## Technical Stack

- **Framework**: Flutter 3.10.8+
- **State Management**: Riverpod 2.6.0
- **Local Storage**: Hive 2.2.3 + Hive Flutter
- **UI**: Material Design

## Project Structure

```
├── android/             # Android native code
├── ios/                 # iOS native code
├── lib/
│   ├── main.dart        # App entry point
│   ├── models/          # Domain models
│   ├── services/        # Repository layer
│   ├── providers/       # Riverpod providers
│   ├── screens/         # Full-screen widgets
│   └── widgets/         # Reusable components
├── test/                # Unit tests
├── pubspec.yaml         # Dependencies
└── README.md           # This file
```

## Getting Started

### Prerequisites
- Flutter SDK 3.10.8 or higher
- Dart 3.10.8 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/masteribro/TaskManager.git
   cd task_manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive code**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build Release APK

```bash
flutter build apk --release
```

The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`

## Usage

### Adding a Task
1. Tap the floating action button (+)
2. Enter task title and description
3. Tap "Add" to create the task

### Editing a Task
1. Tap the edit icon on any task
2. Modify title or description
3. Tap "Update" to save changes

### Completing a Task
- Tap the checkbox next to any task to toggle completion status

### Deleting a Task
1. Swipe left on a task to delete it, or
2. Tap the delete icon in the task actions

### Searching Tasks
- Use the search bar at the top to filter tasks by title or description

## Assumptions & Design Decisions

### Assumptions
- Single user application (no multi-user support needed)
- Task ID generation using timestamp for simplicity
- No cloud sync required (local-only persistence)
- Tasks don't have priority levels (kept simple per requirements)
- No offline sync or conflict resolution needed

### Design Decisions
1. **Riverpod over Provider**: Better type safety, less boilerplate, built-in dependency injection
2. **Hive over SQLite**: Faster setup, minimal configuration, sufficient for local-only needs
3. **Modal dialogs for forms**: Simpler UX than separate screens, less navigation overhead
4. **Dismissible tiles with confirmation**: Familiar gesture pattern with safety confirmation
5. **Search using computed provider**: Reactive filtering without extra button taps
6. **Immutable Task model**: Prevents accidental state mutations, easier debugging

## Error Handling

- Empty title validation with user feedback
- Graceful handling of deleted tasks during operations
- Snackbar notifications for user actions (add, delete, update)
- Dismissible gestures with confirmation dialogs for destructive actions

## Performance Considerations

- **Lazy loading**: Tasks loaded on demand via Riverpod
- **Efficient rebuilds**: Only affected widgets rebuild on state changes
- **Caching**: Riverpod caches computed providers to avoid redundant calculations
- **Local storage**: Instant data persistence without network latency
- **Search filtering**: Computed provider prevents unnecessary list rebuilds

## Testing

Future test files can be added to the `test/` directory:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/task_test.dart
```

## Known Limitations & Future Improvements

### Current Limitations
- No task categories or tags
- No recurring tasks
- No due dates or reminders
- No collaboration features
- Android and iOS only (no Web)

### Future Enhancements
- Task categories/tags for organization
- Due dates with notifications
- Recurring tasks
- Task sorting options (by date, priority)
- Dark mode support
- Cloud synchronization
- Backup and restore functionality

## Challenges Faced

1. **Hive Code Generation**: Initial setup required running build_runner
2. **Riverpod Dependencies**: Proper provider ordering for state management
3. **State Updates**: Ensuring UI reflects all CRUD operations consistently

## Estimated Time Spent

- Setup and architecture: 1.2 hours
- Core implementation: 1 hours
- UI/UX refinement: 1 hours
- Testing and debugging: 1.7 hour
- Documentation: 1.3 hour

**Total: ~6 hours**

## Submission Details

- **Repository**: https://github.com/masteribro/Task-Manager.git
- **APK Build**: https://drive.google.com/file/d/1tro_DbNJHbSz9Tl15jdLl0oQL_8mAAIK/view?usp=sharing
- **Architecture**: Clean Architecture with Riverpod State Management
- **Database**: Hive for local persistence

## License

This project is open source and available under the MIT License.



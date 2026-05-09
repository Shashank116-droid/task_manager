import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/core/utils/firebase_error_handler.dart';
import 'package:task_manager/features/tasks/models/task_model.dart';
import 'package:task_manager/features/tasks/services/task_service.dart';

/// Task filter enum for filtering task lists.
enum TaskFilter { all, completed, pending }

/// Task state management provider with real-time Firestore sync.
class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String? _error;
  TaskFilter _currentFilter = TaskFilter.all;
  StreamSubscription? _tasksSubscription;
  String? _currentUserId;

  // ── Getters ──────────────────────────────────────────────
  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskFilter get currentFilter => _currentFilter;

  /// Returns filtered tasks based on current filter.
  List<TaskModel> get filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.completed:
        return _tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.pending:
        return _tasks.where((t) => t.isPending).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  /// Returns task count statistics.
  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => t.isPending).length;

  /// Initializes the real-time tasks stream for a user.
  void initTasks(String userId) {
    if (_currentUserId == userId) return;
    _currentUserId = userId;
    _tasksSubscription?.cancel();

    _isLoading = true;
    _error = null;
    notifyListeners();

    _tasksSubscription = _taskService
        .tasksStream(userId)
        .listen(
          (tasks) {
            _tasks = tasks;
            _isLoading = false;
            _error = null;
            notifyListeners();
          },
          onError: (e) {
            _error = _taskErrorMessage(
              e,
              fallback: 'Failed to load tasks. Please try again.',
            );
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  /// Adds a new task.
  Future<bool> addTask({
    required String userId,
    required String title,
    required String description,
    required DateTime date,
  }) async {
    try {
      final task = TaskModel(
        id: '',
        title: title.trim(),
        description: description.trim(),
        date: date,
        status: AppConstants.statusPending,
        createdAt: DateTime.now(),
      );
      await _taskService.addTask(userId, task);
      return true;
    } catch (e) {
      _error = _taskErrorMessage(e, fallback: 'Failed to add task.');
      notifyListeners();
      return false;
    }
  }

  /// Updates an existing task.
  Future<bool> updateTask({
    required String userId,
    required TaskModel task,
  }) async {
    try {
      await _taskService.updateTask(userId, task);
      return true;
    } catch (e) {
      _error = _taskErrorMessage(e, fallback: 'Failed to update task.');
      notifyListeners();
      return false;
    }
  }

  /// Deletes a task.
  Future<bool> deleteTask({
    required String userId,
    required String taskId,
  }) async {
    try {
      await _taskService.deleteTask(userId, taskId);
      return true;
    } catch (e) {
      _error = _taskErrorMessage(e, fallback: 'Failed to delete task.');
      notifyListeners();
      return false;
    }
  }

  /// Toggles a task's completion status.
  Future<bool> toggleTaskStatus({
    required String userId,
    required TaskModel task,
  }) async {
    try {
      await _taskService.toggleTaskStatus(userId, task);
      return true;
    } catch (e) {
      _error = _taskErrorMessage(e, fallback: 'Failed to update task status.');
      notifyListeners();
      return false;
    }
  }

  /// Updates the active filter.
  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  /// Clears all state (used on logout).
  void clear() {
    _tasksSubscription?.cancel();
    _tasks = [];
    _isLoading = true;
    _error = null;
    _currentFilter = TaskFilter.all;
    _currentUserId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }

  String _taskErrorMessage(Object error, {required String fallback}) {
    if (error is FirebaseException) {
      return FirebaseErrorHandler.getFirestoreErrorMessage(error);
    }
    return fallback;
  }
}

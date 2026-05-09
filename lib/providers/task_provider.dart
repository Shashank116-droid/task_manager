import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String? _error;
  String _currentFilter = 'All';
  StreamSubscription? _subscription;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentFilter => _currentFilter;

  List<TaskModel> get filteredTasks {
    if (_currentFilter == AppStrings.completed) return _tasks.where((t) => t.status == AppConstants.statusCompleted).toList();
    if (_currentFilter == AppStrings.pending) return _tasks.where((t) => t.status == AppConstants.statusPending).toList();
    return _tasks;
  }

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.status == AppConstants.statusCompleted).length;
  int get pendingCount => _tasks.where((t) => t.status == AppConstants.statusPending).length;

  void fetchTasks(String userId) {
    _subscription?.cancel();
    _isLoading = true;
    notifyListeners();

    _subscription = _taskService.getTasksStream(userId).listen(
      (tasks) {
        _tasks = tasks;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (err) {
        _error = "Could not load tasks.";
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  Future<bool> addTask({required String userId, required String title, required String description, required DateTime date}) async {
    try {
      final task = TaskModel(id: '', title: title, description: description, date: date, status: AppConstants.statusPending, createdAt: DateTime.now());
      await _taskService.addTask(userId, task);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateTask({required String userId, required TaskModel task}) async {
    try {
      await _taskService.updateTask(userId, task);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> toggleTaskStatus({required String userId, required TaskModel task}) async {
    // Only allow marking as completed, do not allow undoing
    if (task.status != AppConstants.statusCompleted) {
      await _taskService.updateTask(userId, task.copyWith(status: AppConstants.statusCompleted));
    }
  }

  Future<bool> deleteTask({required String userId, required String taskId}) async {
    try {
      await _taskService.deleteTask(userId, taskId);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// Helper to provide AppStrings to the provider since it was used in filteredTasks


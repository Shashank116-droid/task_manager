import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/features/tasks/models/task_model.dart';

/// Service handling all Firestore CRUD operations for tasks.
class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns a reference to the tasks subcollection for a given user.
  CollectionReference<Map<String, dynamic>> _tasksRef(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.tasksCollection);
  }

  /// Returns a real-time stream of tasks ordered by creation date.
  Stream<List<TaskModel>> tasksStream(String userId) {
    return _tasksRef(
      userId,
    ).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  /// Adds a new task and returns the generated document ID.
  Future<String> addTask(String userId, TaskModel task) async {
    final docRef = await _tasksRef(userId).add(task.toFirestore());
    return docRef.id;
  }

  /// Updates an existing task.
  Future<void> updateTask(String userId, TaskModel task) async {
    await _tasksRef(userId).doc(task.id).update(task.toFirestore());
  }

  /// Deletes a task by ID.
  Future<void> deleteTask(String userId, String taskId) async {
    await _tasksRef(userId).doc(taskId).delete();
  }

  /// Toggles the completion status of a task.
  Future<void> toggleTaskStatus(String userId, TaskModel task) async {
    final newStatus = task.isCompleted
        ? AppConstants.statusPending
        : AppConstants.statusCompleted;
    await _tasksRef(userId).doc(task.id).update({'status': newStatus});
  }
}

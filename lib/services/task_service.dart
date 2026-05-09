import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../constants/app_constants.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<TaskModel>> getTasksStream(String userId) {
    return _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.tasksCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }

  Future<void> addTask(String userId, TaskModel task) async {
    await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.tasksCollection)
        .add(task.toFirestore());
  }

  Future<void> updateTask(String userId, TaskModel task) async {
    await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.tasksCollection)
        .doc(task.id)
        .update(task.toFirestore());
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.tasksCollection)
        .doc(taskId)
        .delete();
  }
}

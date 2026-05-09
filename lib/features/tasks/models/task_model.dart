import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/core/constants/app_constants.dart';

/// Task model representing a single task document in Firestore.
class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String status;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.createdAt,
  });

  bool get isCompleted => status == AppConstants.statusCompleted;
  bool get isPending => status == AppConstants.statusPending;

  /// Creates a TaskModel from a Firestore document snapshot.
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data();
    return TaskModel.fromMap(
      doc.id,
      rawData is Map<String, dynamic> ? rawData : null,
    );
  }

  /// Creates a TaskModel from raw Firestore map data.
  factory TaskModel.fromMap(String id, Map<String, dynamic>? data) {
    final safeData = data ?? <String, dynamic>{};
    return TaskModel(
      id: id,
      title: _readString(safeData['title']),
      description: _readString(safeData['description']),
      date: _readDate(safeData['date']),
      status: _readStatus(safeData['status']),
      createdAt: _readDate(safeData['createdAt']),
    );
  }

  /// Converts the TaskModel to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Creates a copy with optional overrides.
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? status,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'TaskModel(id: $id, title: $title, status: $status)';

  static String _readString(Object? value) {
    return value is String ? value : '';
  }

  static DateTime _readDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  static String _readStatus(Object? value) {
    if (value == AppConstants.statusCompleted ||
        value == AppConstants.statusPending) {
      return value as String;
    }
    return AppConstants.statusPending;
  }
}

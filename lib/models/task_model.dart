import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';

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

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    return TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  factory TaskModel.fromMap(String id, Map<String, dynamic> data) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      return DateTime.now();
    }

    return TaskModel(
      id: id,
      title: data['title'] is String ? data['title'] : '',
      description: data['description'] is String ? data['description'] : '',
      date: parseDate(data['date']),
      status: data['status'] is String && 
              (data['status'] == AppConstants.statusPending || data['status'] == AppConstants.statusCompleted)
          ? data['status']
          : AppConstants.statusPending,
      createdAt: parseDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? date,
    String? status,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

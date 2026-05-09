import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/constants/app_constants.dart';
import 'package:task_manager/models/task_model.dart';

void main() {
  test('toFirestore stores Firestore-compatible fields', () {
    final dueDate = DateTime(2026, 5, 9);
    final createdAt = DateTime(2026, 5, 8);
    final task = TaskModel(
      id: 'task-1',
      title: 'Submit project',
      description: 'Upload final build',
      date: dueDate,
      status: AppConstants.statusPending,
      createdAt: createdAt,
    );

    final data = task.toFirestore();

    expect(data['title'], 'Submit project');
    expect(data['description'], 'Upload final build');
    expect(data['status'], AppConstants.statusPending);
    expect(data['date'], isA<Timestamp>());
    expect((data['date'] as Timestamp).toDate(), dueDate);
    expect((data['createdAt'] as Timestamp).toDate(), createdAt);
  });

  test('fromMap reads valid task data', () {
    final dueDate = DateTime(2026, 5, 9);
    final createdAt = DateTime(2026, 5, 8);

    final task = TaskModel.fromMap('task-1', {
      'title': 'Submit project',
      'description': 'Upload final build',
      'date': Timestamp.fromDate(dueDate),
      'status': AppConstants.statusCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    });

    expect(task.id, 'task-1');
    expect(task.title, 'Submit project');
    expect(task.description, 'Upload final build');
    expect(task.date, dueDate);
    expect(task.status, AppConstants.statusCompleted);
    expect(task.createdAt, createdAt);
  });

  test('fromMap falls back safely for malformed task data', () {
    final beforeParse = DateTime.now();

    final task = TaskModel.fromMap('task-1', {
      'title': 42,
      'description': false,
      'date': 'not-a-date',
      'status': 'unknown',
      'createdAt': null,
    });

    expect(task.title, '');
    expect(task.description, '');
    expect(task.status, AppConstants.statusPending);
    expect(
      task.date.isAfter(beforeParse.subtract(const Duration(seconds: 1))),
      isTrue,
    );
    expect(
      task.createdAt.isAfter(beforeParse.subtract(const Duration(seconds: 1))),
      isTrue,
    );
  });

  test('copyWith updates selected fields only', () {
    final original = TaskModel(
      id: 'task-1',
      title: 'Old title',
      description: 'Old description',
      date: DateTime(2026, 5, 9),
      status: AppConstants.statusPending,
      createdAt: DateTime(2026, 5, 8),
    );

    final updated = original.copyWith(
      title: 'New title',
      status: AppConstants.statusCompleted,
    );

    expect(updated.id, original.id);
    expect(updated.title, 'New title');
    expect(updated.description, original.description);
    expect(updated.date, original.date);
    expect(updated.status, AppConstants.statusCompleted);
    expect(updated.createdAt, original.createdAt);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('accepts a valid email address', () {
      expect(Validators.email('user@example.com'), isNull);
    });

    test('rejects empty and invalid email addresses', () {
      expect(Validators.email(''), 'Email is required');
      expect(Validators.email('not-an-email'), 'Enter a valid email address');
    });
  });

  group('Validators.password', () {
    test('accepts passwords with at least six characters', () {
      expect(Validators.password('secret1'), isNull);
    });

    test('rejects empty and short passwords', () {
      expect(Validators.password(''), 'Password is required');
      expect(
        Validators.password('123'),
        'Password must be at least 6 characters',
      );
    });
  });

  group('Validators.confirmPassword', () {
    test('accepts matching passwords', () {
      expect(Validators.confirmPassword('secret1', 'secret1'), isNull);
    });

    test('rejects mismatched passwords', () {
      expect(
        Validators.confirmPassword('secret1', 'secret2'),
        'Passwords do not match',
      );
    });
  });

  group('task validators', () {
    test('requires a title and limits title length', () {
      expect(Validators.taskTitle(''), 'Title is required');
      expect(
        Validators.taskTitle('a' * 101),
        'Title must be under 100 characters',
      );
      expect(Validators.taskTitle('Finish report'), isNull);
    });

    test('limits description length', () {
      expect(
        Validators.taskDescription('a' * 501),
        'Description must be under 500 characters',
      );
      expect(Validators.taskDescription('Notes'), isNull);
    });
  });
}

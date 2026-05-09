/// Application-wide constants.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'TaskFlow';
  static const String appTagline = 'Organize. Focus. Achieve.';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';

  // API
  static const String quotesBaseUrl = 'https://api.quotable.io';
  static const String randomQuoteEndpoint = '/random';

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;

  // Task Status
  static const String statusPending = 'pending';
  static const String statusCompleted = 'completed';
}

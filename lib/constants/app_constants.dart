class AppConstants {
  static const String appName = 'TaskFlow';
  static const String appTagline = 'Master your productivity';
  
  // API Endpoints
  static const String quoteApiPrimary = 'https://api.quotable.io/random';
  static const String quoteApiFallback = 'https://api.zenquotes.io/api/random';
  
  // Firestore Collection Paths
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';
  
  // Task Statuses
  static const String statusPending = 'pending';
  static const String statusCompleted = 'completed';
}

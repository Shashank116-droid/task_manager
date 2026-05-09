import 'package:firebase_auth/firebase_auth.dart';

/// Translates Firebase error codes into user-friendly messages.
class FirebaseErrorHandler {
  FirebaseErrorHandler._();

  static String getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }

  static String getFirestoreErrorMessage(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You do not have permission to access these tasks.';
      case 'unavailable':
        return 'Task data is temporarily unavailable. Check your connection and try again.';
      case 'deadline-exceeded':
        return 'The request took too long. Please try again.';
      case 'not-found':
        return 'The requested task could not be found.';
      case 'already-exists':
        return 'This task already exists.';
      case 'resource-exhausted':
        return 'Too many requests. Please wait a moment and try again.';
      case 'cancelled':
        return 'The task request was cancelled. Please try again.';
      case 'unauthenticated':
        return 'Please log in again to manage your tasks.';
      default:
        return e.message ?? 'Something went wrong while syncing tasks.';
    }
  }
}

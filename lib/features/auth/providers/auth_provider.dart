import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/features/auth/models/user_model.dart';
import 'package:task_manager/features/auth/services/auth_service.dart';
import 'package:task_manager/core/utils/firebase_error_handler.dart';

/// Authentication state management provider.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  StreamSubscription<User?>? _authSubscription;

  // ── Getters ──────────────────────────────────────────────
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  /// Initializes auth state by listening to Firebase auth changes.
  /// Called once at app startup.
  Future<void> initialize() async {
    if (_isInitialized) return;

    _user = _userFromFirebase(_authService.currentUser);
    _authSubscription = _authService.authStateChanges.listen(
      (firebaseUser) {
        _user = _userFromFirebase(firebaseUser);
        _isInitialized = true;
        notifyListeners();
      },
      onError: (_) {
        _error = 'Failed to monitor authentication state.';
        _isInitialized = true;
        notifyListeners();
      },
    );

    _isInitialized = true;
    notifyListeners();
  }

  /// Signs up a new user.
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(FirebaseErrorHandler.getAuthErrorMessage(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  /// Signs in an existing user.
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authService.signIn(email: email, password: password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(FirebaseErrorHandler.getAuthErrorMessage(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
    } catch (e) {
      _setError('Failed to sign out. Please try again.');
    }
    _setLoading(false);
  }

  /// Clears any active error message.
  void clearError() => _clearError();

  // ── Private Helpers ──────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

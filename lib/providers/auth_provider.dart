import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/firebase_error_handler.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> initialize() async {
    _authService.userStream.listen((user) {
      _user = user;
      _isInitialized = true;
      notifyListeners();
    });
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();
    try {
      _user = await _authService.login(email: email, password: password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(FirebaseErrorHandler.getAuthErrorMessage(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Login failed. Please check your credentials.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signUp({required String email, required String password, required String name}) async {
    _setLoading(true);
    _clearError();
    try {
      _user = await _authService.signUp(email: email, password: password, name: name);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(FirebaseErrorHandler.getAuthErrorMessage(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Signup failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String value) {
    _error = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

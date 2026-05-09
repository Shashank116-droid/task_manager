import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/features/auth/models/user_model.dart';

/// Service handling all Firebase Authentication operations.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns the current Firebase user.
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes for persistent login.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Converts a Firebase [User] to our [UserModel].
  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  /// Signs up with email and password.
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    // Update display name after signup
    await credential.user?.updateDisplayName(name.trim());
    await credential.user?.reload();
    return _userFromFirebase(_auth.currentUser);
  }

  /// Signs in with email and password.
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _userFromFirebase(credential.user);
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email!, displayName: user.displayName) : null;
  }

  Stream<UserModel?> get userStream {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserModel?> signUp({required String email, required String password, required String name}) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    await credential.user?.updateDisplayName(name.trim());
    await credential.user?.reload();
    return _userFromFirebase(_auth.currentUser);
  }

  Future<UserModel?> login({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    return _userFromFirebase(credential.user);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

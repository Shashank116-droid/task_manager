/// User model wrapping Firebase Auth user data.
class UserModel {
  final String uid;
  final String email;
  final String? displayName;

  UserModel({required this.uid, required this.email, this.displayName});

  @override
  String toString() => 'UserModel(uid: $uid, email: $email)';
}

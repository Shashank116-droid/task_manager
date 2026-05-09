class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Enter a valid name';
    return null;
  }

  static String? confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) return 'Please confirm your password';
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }

  static String? taskTitle(String? value) {
    if (value == null || value.isEmpty) return 'Title is required';
    if (value.length > 100) return 'Title must be under 100 characters';
    return null;
  }

  static String? taskDescription(String? value) {
    if (value == null || value.isEmpty) return 'Description is required';
    if (value.length > 500) return 'Description must be under 500 characters';
    return null;
  }
}

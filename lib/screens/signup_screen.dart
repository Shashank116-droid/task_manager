import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import '../constants/app_strings.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await context.read<AuthProvider>().signUp(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) Navigator.pop(context);
    else if (mounted) SnackBarHelper.showError(context, context.read<AuthProvider>().error ?? AppStrings.genericError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(AppStrings.signupTitle, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(AppStrings.signupSubtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                const SizedBox(height: 40),
                CustomTextField(controller: _nameController, hintText: AppStrings.nameHint, prefixIcon: Icons.person_outline, validator: Validators.name),
                const SizedBox(height: 16),
                CustomTextField(controller: _emailController, hintText: AppStrings.emailHint, prefixIcon: Icons.email_outlined, validator: Validators.email, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                CustomTextField(controller: _passwordController, hintText: AppStrings.passwordHint, prefixIcon: Icons.lock_outline, isPassword: true, validator: Validators.password),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => PrimaryButton(text: AppStrings.signupButton, isLoading: auth.isLoading, onPressed: _handleSignup),
                ),
              ],
            ).animate().slideX(begin: 0.1, duration: 600.ms, curve: Curves.easeOut),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/kidme_button.dart';
import '../../../widgets/kidme_card.dart';
import '../../../widgets/kidme_logo.dart';
import '../../jobs/screens/job_feed_screen.dart';

/// The [LoginScreen] handles existing user authentication.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _supabaseService = SupabaseService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _supabaseService.signIn(email: email, password: password);
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const JobFeedScreen(),
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          children: [
            const KidmeLogo(),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [AppColors.primaryNavy, AppColors.professionalBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back.',
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Continue your recruitment journey with trusted jobs and verified organizations.',
                    style: TextStyle(color: Color(0xDDEFFFFF), height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            KidmeCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign in',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _AuthField(
                    label: 'Email address',
                    icon: Icons.mail_outline_rounded,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  _AuthField(
                    label: 'Password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 18),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    KidmeButton(
                      label: 'Open dashboard',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _handleLogin,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.icon,
    required this.controller,
    this.obscureText = false,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/kidme_backend_scope.dart';
import '../theme/app_colors.dart';
import 'job_feed_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    this.role = 'Job Seeker',
    this.recruiterType,
  });

  final String role;
  final String? recruiterType;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  late String _currentRole;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _currentRole = widget.role;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'All fields are required.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final service = KidmeBackendScope.of(context);
    try {
      await service.signUpWithPassword(
        email: email,
        password: password,
        fullName: fullName,
        role: _currentRole,
        recruiterType: widget.recruiterType,
      );

      if (!mounted) return;

      if (service.isSignedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const JobFeedScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Account created. Please confirm your email.')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => LoginScreen(role: _currentRole)),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _friendlyAuthError(error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  backgroundColor: AppColors.cardBorder.withAlpha(100),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 18, color: AppColors.primaryNavy),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your new account',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  _buildRoleToggle(),
                  const SizedBox(height: 30),
                  _buildTextField(
                    controller: _fullNameController,
                    hintText: 'Full Name',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'user@gmail.com',
                    icon: Icons.mail_outline_rounded,
                    suffixIcon: Icons.check,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: '********',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        _isLoading ? 'Creating...' : 'Sign Up',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.primaryNavy, size: 20),
                      const SizedBox(width: 8),
                      const Text('Remember Me', style: TextStyle(color: Colors.grey)),
                      const Spacer(),
                      const Text('Forget Password?', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or continue with', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialIcon(icon: Icons.facebook, color: Colors.blue),
                      const SizedBox(width: 20),
                      _SocialIcon(image: 'https://pngimg.com/uploads/google/google_PNG19635.png'),
                      const SizedBox(width: 20),
                      _SocialIcon(icon: Icons.apple, color: Colors.black),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ', style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => LoginScreen(role: _currentRole),
                          ),
                        ),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: AppColors.primaryNavy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleToggle() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.cardBorder.withAlpha(50),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentRole = 'Job Seeker'),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _currentRole == 'Job Seeker' ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _currentRole == 'Job Seeker'
                      ? [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10)]
                      : null,
                ),
                child: Text(
                  'Job Seeker',
                  style: TextStyle(
                    color: _currentRole == 'Job Seeker' ? AppColors.primaryNavy : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentRole = 'Recruiter'),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _currentRole == 'Recruiter' ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _currentRole == 'Recruiter'
                      ? [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10)]
                      : null,
                ),
                child: Text(
                  'Recruiter',
                  style: TextStyle(
                    color: _currentRole == 'Recruiter' ? AppColors.primaryNavy : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    IconData? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBorder.withAlpha(100),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black54),
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.black38),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: AppColors.primaryNavy, size: 18)
              : (isPassword ? const Icon(Icons.visibility_outlined, color: Colors.black54) : null),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({this.icon, this.image, this.color});
  final IconData? icon;
  final String? image;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Center(
        child: image != null
            ? Image.network(image!, width: 25)
            : Icon(icon, color: color, size: 30),
      ),
    );
  }
}

String _friendlyAuthError(Object error) {
  if (error is AuthException) return error.message;
  if (error is PostgrestException) return error.message;
  return 'Something went wrong. Please check your connection and try again.';
}

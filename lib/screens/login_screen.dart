import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/kidme_button.dart';
import '../widgets/kidme_card.dart';
import '../widgets/kidme_logo.dart';
import 'job_feed_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.role = 'Job Seeker', this.recruiterType});

  final String role;
  final String? recruiterType;

  @override
  Widget build(BuildContext context) {
    final isRecruiter = role == 'Recruiter';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            _AuthTopBar(onBack: () => Navigator.of(context).maybePop()),
            const SizedBox(height: 22),
            _AuthHero(
              title: 'Welcome Back',
              subtitle: isRecruiter
                  ? 'Manage candidates and continue building trusted teams.'
                  : 'Continue building your verified career profile.',
            ),
            const SizedBox(height: 20),
            KidmeCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign in',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recruiterType ?? role,
                    style: const TextStyle(
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _AuthField(
                    label: 'Email address',
                    icon: Icons.mail_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  const _AuthField(
                    label: 'Password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: true,
                    suffixIcon: Icons.visibility_rounded,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.premiumGold,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      const Text('Remember me'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  KidmeButton(
                    label: 'Login',
                    icon: Icons.login_rounded,
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const JobFeedScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _SocialAuthRow(),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RegisterScreen(
                        role: role,
                        recruiterType: recruiterType,
                      ),
                    ),
                  ),
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTopBar extends StatelessWidget {
  const _AuthTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primaryNavy,
            foregroundColor: Colors.white,
          ),
        ),
        const Spacer(),
        const _LanguageSelector(),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'fr', child: Text('Francais')),
        PopupMenuItem(value: 'en', child: Text('English')),
        PopupMenuItem(value: 'ar', child: Text('Arabic')),
      ],
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language_rounded, color: AppColors.primaryNavy),
          SizedBox(width: 6),
          Text('Languages', style: TextStyle(fontWeight: FontWeight.w800)),
          Icon(Icons.keyboard_arrow_down_rounded),
        ],
      ),
    );
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [AppColors.softMint, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          const KidmeLogo(iconSize: 78, textSize: 34),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontSize: 34),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.softGrey, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String label;
  final IconData icon;
  final bool obscureText;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
      ),
    );
  }
}

class _SocialAuthRow extends StatelessWidget {
  const _SocialAuthRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('Or continue with'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _SocialCircle(label: 'G'),
            SizedBox(width: 16),
            _SocialCircle(label: 'A'),
            SizedBox(width: 16),
            _SocialCircle(label: 'K'),
          ],
        ),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.white,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primaryNavy,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

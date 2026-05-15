import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/kidme_button.dart';
import '../widgets/kidme_card.dart';
import '../widgets/kidme_logo.dart';
import 'job_feed_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({
    super.key,
    this.role = 'Job Seeker',
    this.recruiterType,
  });

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
            Row(
              children: [
                IconButton.filled(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                  ),
                ),
                const Spacer(),
                const _LanguageSelector(),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Register',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontSize: 38),
            ),
            const SizedBox(height: 8),
            Text(
              isRecruiter
                  ? 'Create your recruiter account'
                  : 'Create your new candidate account',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: AppColors.softGrey),
            ),
            const SizedBox(height: 24),
            KidmeCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const KidmeLogo(iconSize: 42, textSize: 24),
                      const Spacer(),
                      Chip(
                        label: Text(recruiterType ?? role),
                        backgroundColor: AppColors.softMint,
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const _AuthField(
                    label: 'Full name',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 12),
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
                  if (!isRecruiter) ...[
                    const SizedBox(height: 12),
                    const _AuthField(
                      label: 'National Identity Number',
                      icon: Icons.badge_outlined,
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.premiumGold,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text('Remember me'),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          'Secure Supabase-ready flow',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  KidmeButton(
                    label: 'Create Account',
                    icon: Icons.verified_user_outlined,
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
            const SizedBox(height: 18),
            if (!isRecruiter) const _CandidateTrustCard(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          LoginScreen(role: role, recruiterType: recruiterType),
                    ),
                  ),
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ],
        ),
      ),
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

class _CandidateTrustCard extends StatelessWidget {
  const _CandidateTrustCard();

  @override
  Widget build(BuildContext context) {
    return KidmeCard(
      color: const Color(0xFFFBFFFD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Build a trusted profile',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const _TrustItem(
            icon: Icons.verified_outlined,
            title: 'Professional verification badge',
            subtitle: 'Verify phone, email, ID, diploma, and certificates.',
          ),
          const _TrustItem(
            icon: Icons.description_outlined,
            title: 'AI CV builder',
            subtitle: 'Create an ATS-friendly CV from your profile data.',
          ),
          const _TrustItem(
            icon: Icons.video_camera_front_outlined,
            title: 'Video introduction',
            subtitle:
                'Show communication skills in French, English, or Arabic.',
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.emerald),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(subtitle),
              ],
            ),
          ),
        ],
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

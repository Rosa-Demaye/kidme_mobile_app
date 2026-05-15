import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/kidme_button.dart';
import '../widgets/kidme_logo.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.softMint, AppColors.mist],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: Column(
              children: [
                const Spacer(),
                const KidmeLogo(iconSize: 118, textSize: 62),
                const SizedBox(height: 46),
                Text(
                  'The Smartest Way to Connect Seekers to Recruiters.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 28,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Build credibility, apply faster, and discover trusted opportunities in Chad.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.softGrey, height: 1.45),
                ),
                const Spacer(),
                KidmeButton(
                  label: 'Get Started',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const OnboardingScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

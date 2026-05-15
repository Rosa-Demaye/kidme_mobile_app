import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/kidme_logo.dart';
import 'onboarding_screen.dart';

/// Initial landing screen that provides brand recognition while the app initializes.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  /// Simulate a brief initialization period before moving to Onboarding.
  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero-style logo for the splash screen
            Transform.scale(
              scale: 1.5,
              child: const KidmeLogo(),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 40,
              height: 2,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

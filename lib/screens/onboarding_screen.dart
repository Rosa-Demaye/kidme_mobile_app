import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/kidme_button.dart';
import '../widgets/kidme_logo.dart';
import 'role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const RoleSelectionScreen()),
      );
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final slides = [
      const _OnboardingSlide(
        eyebrow: 'For job seekers',
        title: 'Find Your Dream Career',
        subtitle:
            'Create a verified profile, build a professional CV, track applications, and get discovered by trusted recruiters.',
        icon: Icons.person_search_rounded,
        chips: ['Verified profile', 'Smart matching', 'CV builder'],
      ),
      const _OnboardingSlide(
        eyebrow: 'For recruiters',
        title: 'Source Top Talent Fast',
        subtitle:
            'Post jobs, filter credible candidates, shortlist quickly, and communicate professionally from one mobile workflow.',
        icon: Icons.groups_rounded,
        chips: ['Verified talent', 'Shortlists', 'Messaging'],
      ),
      const _OnboardingSlide(
        eyebrow: 'Built for Chad',
        title: 'A Career Ecosystem',
        subtitle:
            'Multilingual profiles, scam reporting, local categories, low-data UX, and skill growth tools for serious hiring.',
        icon: Icons.verified_user_rounded,
        chips: ['French', 'English', 'Arabic'],
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          child: Column(
            children: [
              Row(
                children: [
                  const KidmeLogo(iconSize: 32, textSize: 22),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const RoleSelectionScreen(),
                      ),
                    ),
                    child: const Text('Skip'),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _page = value),
                  children: slides,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 7,
                    width: _page == index ? 26 : 8,
                    decoration: BoxDecoration(
                      color: _page == index
                          ? AppColors.primaryNavy
                          : AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              KidmeButton(
                label: _page == 2 ? 'Choose my role' : 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.chips,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> chips;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 230,
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            gradient: const LinearGradient(
              colors: [AppColors.softMint, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 132,
                  width: 132,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryNavy, AppColors.emerald],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(42),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryNavy.withAlpha(45),
                        blurRadius: 34,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 70),
                ),
              ),
              const Positioned(
                right: 12,
                top: 10,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.premiumGold,
                ),
              ),
              const Positioned(
                left: 10,
                bottom: 8,
                child: Icon(Icons.check_circle_rounded, color: AppColors.mint),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        Text(
          eyebrow.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.emerald,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.softGrey, height: 1.5),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: chips
              .map(
                (chip) => Chip(
                  label: Text(chip),
                  backgroundColor: AppColors.softMint,
                  side: BorderSide.none,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

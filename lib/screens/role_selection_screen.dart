import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/kidme_button.dart';
import '../widgets/kidme_logo.dart';
import 'login_screen.dart';

enum KidmeRole { recruiter, jobSeeker }

enum RecruiterType { gigs, enterprise }

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  KidmeRole _role = KidmeRole.recruiter;
  RecruiterType _recruiterType = RecruiterType.gigs;

  String get _recruiterTypeLabel {
    return _recruiterType == RecruiterType.gigs
        ? 'Small Gigs & Individuals'
        : 'Enterprise & Corporate';
  }

  void _continue() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => LoginScreen(
          role: _role == KidmeRole.recruiter ? 'Recruiter' : 'Job Seeker',
          recruiterType: _role == KidmeRole.recruiter
              ? _recruiterTypeLabel
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                children: [
                  const KidmeLogo(iconSize: 34, textSize: 26),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.language_rounded),
                    tooltip: 'Languages',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'Settings',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                children: [
                  Text(
                    'Set Up Your Profile',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose the role that best matches your goal',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _RoleCard(
                    selected: _role == KidmeRole.recruiter,
                    icon: Icons.business_center_outlined,
                    title: 'I am a Recruiter',
                    subtitle: 'Post jobs, source candidates, and build teams.',
                    onTap: () => setState(() => _role = KidmeRole.recruiter),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _role == KidmeRole.recruiter
                          ? Column(
                        key: const ValueKey('recruiter-options'),
                        children: [
                          const SizedBox(height: 14),
                          _RecruiterBranch(
                            selected:
                            _recruiterType == RecruiterType.gigs,
                            title: 'Small Gigs & Individuals',
                            subtitle:
                            'Hire informal help, quick tasks, one-off projects.',
                            icon: Icons.storefront_outlined,
                            onTap: () => setState(
                                  () => _recruiterType = RecruiterType.gigs,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _RecruiterBranch(
                            selected:
                            _recruiterType ==
                                RecruiterType.enterprise,
                            title: 'Enterprise & Corporate',
                            subtitle:
                            'Post vacancies for formal roles and permanent staff.',
                            icon: Icons.apartment_rounded,
                            onTap: () => setState(
                                  () => _recruiterType =
                                  RecruiterType.enterprise,
                            ),
                          ),
                        ],
                      )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _RoleCard(
                    selected: _role == KidmeRole.jobSeeker,
                    icon: Icons.person_outline_rounded,
                    title: 'I am a Job Seeker',
                    subtitle:
                    'Find work, browse postings, and build your career.',
                    onTap: () => setState(() => _role = KidmeRole.jobSeeker),
                  ),
                  const SizedBox(height: 18),
                  _FeatureStrip(
                    items: _role == KidmeRole.recruiter
                        ? const [
                      ('Fast filters', Icons.tune_rounded),
                      ('Shortlists', Icons.playlist_add_check_rounded),
                      ('Verified talent', Icons.verified_rounded),
                    ]
                        : const [
                      ('AI CV builder', Icons.description_outlined),
                      ('Job matching', Icons.auto_awesome_rounded),
                      ('Application tracker', Icons.timeline_rounded),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
              child: KidmeButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.child,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.softMint : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppColors.primaryNavy : AppColors.cardBorder,
            width: selected ? 1.6 : 1,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: AppColors.emerald.withAlpha(34),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                      colors: [AppColors.primaryNavy, AppColors.emerald],
                    )
                        : null,
                    color: selected ? null : AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: selected ? Colors.white : AppColors.softGrey,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle),
                    ],
                  ),
                ),
              ],
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

class _RecruiterBranch extends StatelessWidget {
  const _RecruiterBranch({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.mint.withAlpha(130) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primaryNavy : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.primaryNavy : AppColors.softGrey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(subtitle, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Icon(icon, color: AppColors.primaryNavy),
          ],
        ),
      ),
    );
  }
}

class _FeatureStrip extends StatelessWidget {
  const _FeatureStrip({required this.items});

  final List<(String, IconData)> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => Chip(
          avatar: Icon(item.$2, size: 17, color: AppColors.primaryNavy),
          label: Text(item.$1),
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      )
          .toList(),
    );
  }
}

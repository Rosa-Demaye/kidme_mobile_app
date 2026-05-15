import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/kidme_card.dart';
import 'register_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Type'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How will you use Kidme?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose the role that best describes your needs to personalize your experience.",
              style: TextStyle(color: AppColors.softGrey),
            ),
            const SizedBox(height: 32),
            _RoleCard(
              title: 'I am a Candidate',
              description: 'I am looking for job opportunities and career growth in Chad.',
              icon: Icons.person_search_rounded,
              onTap: () => _navigateToRegister(context, 0),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              title: 'I am an Employer',
              description: 'I represent a company or NGO looking to recruit top talent.',
              icon: Icons.business_center_rounded,
              onTap: () => _navigateToRegister(context, 1),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRegister(BuildContext context, int initialRole) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: KidmeCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blueMist,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AppColors.professionalBlue,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.softGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.softGrey,
            ),
          ],
        ),
      ),
    );
  }
}

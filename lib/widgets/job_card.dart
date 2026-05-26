import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class JobCard extends StatelessWidget {
  const JobCard({
    super.key,
    required this.company,
    required this.role,
    required this.location,
    required this.salary,
    required this.match,
    required this.status,
    required this.onTap,
    this.isVerifiedRecruiter = true,
  });

  final String company;
  final String role;
  final String location;
  final String salary;
  final int match;
  final String status;
  final VoidCallback onTap;
  final bool isVerifiedRecruiter;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    child: Text(company.substring(0, 1)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              role,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (isVerifiedRecruiter) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: AppColors.professionalBlue,
                              ),
                            ],
                          ],
                        ),
                        Text('$company - $location'),
                      ],
                    ),
                  ),
                  _Pill(text: status, color: AppColors.blueMist),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Pill(text: salary, color: AppColors.warmMist),
                  const _Pill(text: 'Full-time', color: AppColors.blueMist),
                  const _Pill(
                    text: 'Remote friendly',
                    color: AppColors.blueMist,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 7,
                              value: match / 100,
                              backgroundColor: AppColors.cardBorder,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.emerald,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$match% match',
                          style: const TextStyle(
                            color: AppColors.emerald,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _WhatsAppButton(onTap: () {}),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhatsAppButton extends StatelessWidget {
  final VoidCallback onTap;
  const _WhatsAppButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF25D366).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.chat_rounded,
          color: Color(0xFF25D366),
          size: 20,
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryNavy,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

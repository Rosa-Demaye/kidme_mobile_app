import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class KidmeLogo extends StatelessWidget {
  const KidmeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: AppColors.primaryNavy,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.work_rounded,
            color: AppColors.goldAccent,
            size: 19,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Kidme',
          style: TextStyle(
            color: AppColors.primaryNavy,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

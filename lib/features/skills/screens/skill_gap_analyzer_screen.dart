import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/skill_model.dart';

class SkillGapAnalyzerScreen extends StatelessWidget {
  const SkillGapAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentSkills = [
      Skill(name: 'Flutter Development', level: 0.8),
      Skill(name: 'UI/UX Design', level: 0.6),
      Skill(name: 'Dart', level: 0.9),
      Skill(name: 'PostgreSQL', level: 0.5),
    ];

    final recommendedSkills = [
      Skill(
        name: 'State Management (Bloc/Riverpod)',
        level: 0.3,
        isMissing: true,
      ),
      Skill(name: 'Automated Testing', level: 0.2, isMissing: true),
      Skill(name: 'Supabase Auth & RLS', level: 0.4, isMissing: true),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Gap Analyzer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnalysisHeader(),
            const SizedBox(height: 32),
            const Text(
              'Your Top Skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 16),
            ...currentSkills.map((s) => _SkillProgressTile(skill: s)),
            const SizedBox(height: 32),
            const Text(
              'Identified Gaps (Recommended)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Skills frequently required for "Senior Flutter" roles in Chad.',
              style: TextStyle(color: AppColors.softGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ...recommendedSkills.map((s) => _SkillProgressTile(skill: s)),
            const SizedBox(height: 32),
            _LearnCTA(),
          ],
        ),
      ),
    );
  }
}

class _AnalysisHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blueMist,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.psychology_rounded,
            size: 40,
            color: AppColors.professionalBlue,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '70% Ready',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryNavy,
                  ),
                ),
                Text(
                  'Matching Senior Flutter roles',
                  style: TextStyle(color: AppColors.softGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillProgressTile extends StatelessWidget {
  final Skill skill;

  const _SkillProgressTile({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                '${(skill.level * 100).toInt()}%',
                style: TextStyle(
                  color: skill.isMissing
                      ? Colors.deepOrange
                      : AppColors.emerald,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: skill.level,
              minHeight: 8,
              backgroundColor: AppColors.cardBorder,
              valueColor: AlwaysStoppedAnimation(
                skill.isMissing
                    ? Colors.deepOrange.withValues(alpha: 0.5)
                    : AppColors.emerald,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text(
            'Close the gap today',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We found 3 free courses to help you master Testing and Supabase.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldAccent,
              foregroundColor: AppColors.primaryNavy,
            ),
            child: const Text('View Courses'),
          ),
        ],
      ),
    );
  }
}

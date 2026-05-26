import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/project_model.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      Project(
        id: '1',
        title: 'Kidme Mobile App',
        description:
            'A professional recruitment platform built with Flutter and Supabase to connect talent in Chad.',
        technologies: ['Flutter', 'Supabase', 'Dart'],
        githubLink: 'https://github.com/Rosa-Demaye/kidme_mobile_app',
      ),
      Project(
        id: '2',
        title: 'E-Health Chad',
        description:
            'A telemedicine application prototype for rural areas in Chad, focusing on offline data sync.',
        technologies: ['Flutter', 'Firebase', 'Node.js'],
      ),
      Project(
        id: '3',
        title: 'Local NGO Tracker',
        description:
            'Real-time tracking of humanitarian aid distribution and logistics management.',
        technologies: ['React Native', 'PostgreSQL'],
        liveLink: 'https://ngo-tracker-demo.com',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects Portfolio'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Project',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return _ProjectCard(project: project);
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.blueMist,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: const Icon(
              Icons.code_rounded,
              size: 48,
              color: AppColors.professionalBlue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: const TextStyle(
                    color: AppColors.softGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies
                      .map((tech) => _TechChip(label: tech))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (project.githubLink != null)
                      _LinkButton(
                        icon: Icons.link_rounded,
                        label: 'GitHub',
                        onTap: () {},
                      ),
                    if (project.liveLink != null) ...[
                      const SizedBox(width: 12),
                      _LinkButton(
                        icon: Icons.rocket_launch_rounded,
                        label: 'Live Demo',
                        onTap: () {},
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;

  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.emerald,
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryNavy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

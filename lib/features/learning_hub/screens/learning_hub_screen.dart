import 'package:flutter/material.dart';
import '../../../core/services/supabase_service.dart';
import '../../../theme/app_colors.dart';

class LearningHubScreen extends StatefulWidget {
  const LearningHubScreen({super.key});

  @override
  State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  final _supabaseService = SupabaseService();
  late Future<List<Map<String, String>>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _supabaseService.getLearningHubContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Learning Hub'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HubHero(),
            const SizedBox(height: 24),
            Text(
              'Recommended for you',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, String>>>(
              future: _contentFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Text('Failed to load learning content.');
                }
                return Column(
                  children: snapshot.data!
                      .map(
                        (item) => _LearningCard(
                          title: item['title']!,
                          category: item['category']!,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            const _ScholarshipSection(),
          ],
        ),
      ),
    );
  }
}

class _HubHero extends StatelessWidget {
  const _HubHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.deepGreen, AppColors.emerald],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.school_rounded,
            color: AppColors.goldAccent,
            size: 40,
          ),
          const SizedBox(height: 16),
          const Text(
            'Improve Your Employability',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get tips on interviews, CV building, and local market demand in Chad.',
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}

class _LearningCard extends StatelessWidget {
  final String title;
  final String category;

  const _LearningCard({required this.title, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.blueMist,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: AppColors.professionalBlue,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          category,
          style: const TextStyle(color: AppColors.emerald),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.softGrey,
        ),
        onTap: () {},
      ),
    );
  }
}

class _ScholarshipSection extends StatelessWidget {
  const _ScholarshipSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scholarships & Grants',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: [
              Icon(Icons.stars_rounded, color: AppColors.goldAccent),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Explore 15+ available scholarships for Chadian students.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../core/services/supabase_service.dart';
import '../features/chat/screens/conversation_list_screen.dart';
import '../features/cv_builder/screens/cv_builder_screen.dart';
import '../features/events/screens/calendar_screen.dart';
import '../features/events/screens/events_for_you_screen.dart';
import '../features/jobs/models/job_model.dart';
import '../features/learning_hub/screens/learning_hub_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/portfolio/screens/portfolio_screen.dart';
import '../features/skills/screens/skill_gap_analyzer_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/job_card.dart';
import '../widgets/kidme_logo.dart';

class JobFeedScreen extends StatefulWidget {
  const JobFeedScreen({super.key});

  @override
  State<JobFeedScreen> createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends State<JobFeedScreen> {
  int _tabIndex = 0;
  final _supabaseService = SupabaseService();
  late Future<List<Job>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = _supabaseService.getJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _tabIndex,
          children: [
            _HomeTab(jobsFuture: _jobsFuture),
            const EventsForYouScreen(),
            const LearningHubScreen(),
            const ConversationListScreen(),
            _ProfileTab(onOpenCalendar: () => setState(() => _tabIndex = 5)),
            const CalendarScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex > 4 ? 4 : _tabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.blueMist,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Learning',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.jobsFuture});

  final Future<List<Job>> jobsFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: jobsFuture,
      builder: (context, snapshot) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const KidmeLogo(),
                        const Spacer(),
                        IconButton.filledTonal(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications_none_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _HeroPanel(),
                    const SizedBox(height: 18),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search NGO, Oil, Banking...',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _CategoryChips(),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Smart recommendations',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('View all'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (snapshot.connectionState == ConnectionState.waiting)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (snapshot.hasError)
              SliverFillRemaining(
                child: Center(child: Text('Error: ${snapshot.error}')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final job = snapshot.data![index];
                    return JobCard(
                      company: job.company,
                      role: job.role,
                      location: job.location,
                      salary: job.salary,
                      match: job.match,
                      status: job.status,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => JobDetailScreen(job: job),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavy, AppColors.professionalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.professionalBlue.withAlpha(51),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GoldBadge(text: 'Jobs in Chad - Recruiters verified'),
          const SizedBox(height: 20),
          Text(
            'Find serious work faster.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontSize: 31,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Build one trusted Kidme profile and apply to companies, NGOs, and institutions in a few taps.',
            style: TextStyle(color: Color(0xDDEFFFFF), height: 1.45),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: AppColors.primaryNavy,
                  ),
                  child: const Text('Complete profile'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(46),
                ),
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    const categories = [
      'All',
      'NGO',
      'Oil & Gas',
      'Telecom',
      'Banking',
      'Remote',
      'Gov',
    ];
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == 0;
          return FilterChip(
            selected: selected,
            onSelected: (_) {},
            label: Text(categories[index]),
            selectedColor: AppColors.primaryNavy,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.primaryNavy,
              fontWeight: FontWeight.w700,
            ),
          );
        },
      ),
    );
  }
}

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job description'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.report_problem_outlined, color: Colors.red),
            tooltip: 'Report Scam',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        child: Text(job.company.substring(0, 1)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.role,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text('${job.company} - ${job.location}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _InfoPill(
                        icon: Icons.schedule_rounded,
                        text: 'Full-time',
                      ),
                      _InfoPill(
                        icon: Icons.wifi_tethering_rounded,
                        text: 'Remote friendly',
                      ),
                      _InfoPill(
                        icon: Icons.verified_rounded,
                        text: 'Verified recruiter',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('About the role', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            job.description ??
                'Join a growing team building useful digital services for Chad. You will collaborate with product, design, and operations teams to deliver reliable mobile experiences for candidates and recruiters.',
          ),
          const SizedBox(height: 20),
          Text('Requirements', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (job.requirements != null && job.requirements!.isNotEmpty)
            ...job.requirements!.map((r) => _Requirement(text: r))
          else ...const [
            _Requirement(
              text: 'Strong communication and professional discipline',
            ),
            _Requirement(
              text:
                  'Experience with mobile apps, customer support, or field work',
            ),
            _Requirement(
              text:
                  'Complete profile with diploma, ID, and recent criminal record',
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Apply now'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.chat_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                ),
                tooltip: 'Contact via WhatsApp',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApplicationsTab extends StatefulWidget {
  const _ApplicationsTab();

  @override
  State<_ApplicationsTab> createState() => _ApplicationsTabState();
}

class _ApplicationsTabState extends State<_ApplicationsTab> {
  final _supabaseService = SupabaseService();
  late Future<List<Map<String, dynamic>>> _trackerFuture;

  @override
  void initState() {
    super.initState();
    _trackerFuture = _supabaseService.getApplicationTracker();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Application Status',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 14),
        const _ProgressCard(
          title: 'Profile Readiness',
          subtitle: 'Verify your ID and Degree to reach 100%.',
          progress: 0.85,
        ),
        const SizedBox(height: 14),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _trackerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LinearProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Unable to load tracking data.');
            }
            return Column(
              children: snapshot.data!
                  .map(
                    (step) => _TimelineStep(
                      title: step['title'],
                      active: step['active'],
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _RecruiterPreviewTab extends StatelessWidget {
  const _RecruiterPreviewTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Recruiter preview',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'For companies, NGOs, and institutions managing their offers.',
        ),
        const SizedBox(height: 18),
        const _MetricGrid(),
        const SizedBox(height: 18),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top candidates',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
                SizedBox(height: 14),
                _CandidateRow(
                  name: 'Amina Mahamat',
                  role: 'Mobile support agent',
                  score: '96%',
                ),
                _CandidateRow(
                  name: 'Oumar Ali',
                  role: 'Finance assistant',
                  score: '91%',
                ),
                _CandidateRow(
                  name: 'Grace Ngarlem',
                  role: 'UX trainee',
                  score: '88%',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.onOpenCalendar});

  final VoidCallback onOpenCalendar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Profile',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _ProfileHeaderCard(),
          const SizedBox(height: 24),
          const _VerificationBadgeSection(),
          const SizedBox(height: 24),
          _ProfileSection(
            title: 'Contact Information',
            child: Column(
              children: const [
                _ContactRow(
                  icon: Icons.email_outlined,
                  text: 'rosa.demaye@email.com',
                ),
                _ContactRow(
                  icon: Icons.phone_android_outlined,
                  text: '+235 60 00 00 00',
                ),
                _ContactRow(
                  icon: Icons.location_on_outlined,
                  text: "N'Djamena, Chad",
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _ProfileSection(
            title: 'Professional Experience',
            child: Column(
              children: const [
                _ExperienceItem(
                  role: 'Junior Developer',
                  company: 'Fale Tech',
                  period: '2025 - Present',
                ),
                _ExperienceItem(
                  role: 'Intern',
                  company: 'UNICEF Chad',
                  period: '2024 - 2025',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _ProfileSection(
            title: 'Languages',
            child: Row(
              children: const [
                _TechChip(
                  label: 'French (Native)',
                  color: AppColors.primaryNavy,
                ),
                SizedBox(width: 8),
                _TechChip(
                  label: 'Arabic (Bilingual)',
                  color: AppColors.primaryNavy,
                ),
                SizedBox(width: 8),
                _TechChip(label: 'English (B2)', color: AppColors.primaryNavy),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Achievements & Growth',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          const _BadgeGrid(),
          const SizedBox(height: 24),
          const Text(
            'Expert Ecosystem Tools',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          _ProfileFeature(
            icon: Icons.video_camera_front_outlined,
            title: 'Video Introduction',
            subtitle: 'Pitch yourself in French or Arabic.',
            status: 'Add video',
            onTap: () {},
          ),
          _ProfileFeature(
            icon: Icons.description_outlined,
            title: 'AI CV Builder',
            subtitle: 'Export an ATS-friendly PDF.',
            status: 'Draft ready',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CVBuilderScreen()),
              );
            },
          ),
          _ProfileFeature(
            icon: Icons.workspaces_outline,
            title: 'Portfolio and projects',
            subtitle: 'GitHub links, project images, and research.',
            status: '2 projects',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PortfolioScreen()),
              );
            },
          ),
          _ProfileFeature(
            icon: Icons.psychology_alt_outlined,
            title: 'Skill gap analyzer',
            subtitle: 'See missing skills for your dream role.',
            status: '70% ready',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SkillGapAnalyzerScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onOpenCalendar,
            icon: const Icon(Icons.calendar_month_rounded),
            label: const Text('Open My Calendar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Recruiter preview')),
                    body: const _RecruiterPreviewTab(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.business_center_outlined),
            label: const Text('Open Recruiter Preview'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.blueMist,
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: AppColors.professionalBlue,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rosa Demaye',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      const Text('Verified graduate - Open to work'),
                      Row(
                        children: const [
                          Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: AppColors.professionalBlue,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Kidme Pro Verified',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.professionalBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _ProgressCard(
              title: 'Profile Power',
              subtitle: 'Top 10% of applicants in Chad',
              progress: 0.85,
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationBadgeSection extends StatelessWidget {
  const _VerificationBadgeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trust & Verification',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _VerificationBadge(label: 'ID Card', isVerified: true),
            _VerificationBadge(label: 'Degree', isVerified: true),
            _VerificationBadge(label: 'Phone', isVerified: false),
          ],
        ),
        const SizedBox(height: 14),
        const _ProfileFeature(
          icon: Icons.verified_outlined,
          title: 'Professional verification',
          subtitle: 'ID, diploma, phone, email, and certificate checks.',
          status: '3/5 verified',
        ),
        const _ProfileFeature(
          icon: Icons.description_outlined,
          title: 'AI CV builder',
          subtitle: 'Export an ATS-friendly PDF from profile data.',
          status: 'Draft ready',
        ),
        const _ProfileFeature(
          icon: Icons.video_camera_front_outlined,
          title: 'Video introduction',
          subtitle: 'Record a short pitch in French, English, or Arabic.',
          status: 'Add video',
        ),
        const _ProfileFeature(
          icon: Icons.workspaces_outline,
          title: 'Portfolio and projects',
          subtitle: 'GitHub links, certificates, project images, and research.',
          status: '2 projects',
        ),
        const _ProfileFeature(
          icon: Icons.psychology_alt_outlined,
          title: 'Skill gap analyzer',
          subtitle: 'See missing skills before applying to a role.',
          status: '70% ready',
        ),
        const _ProfileFeature(
          icon: Icons.timeline_rounded,
          title: 'Application tracking',
          subtitle: 'Applied, viewed, shortlisted, interview, accepted.',
          status: '6 active',
        ),
      ],
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  final String label;
  final bool isVerified;
  const _VerificationBadge({required this.label, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isVerified ? AppColors.softMint : AppColors.softWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isVerified ? AppColors.emerald : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isVerified ? Icons.check_circle_rounded : Icons.pending_rounded,
            size: 16,
            color: isVerified ? AppColors.emerald : AppColors.softGrey,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isVerified ? AppColors.emerald : AppColors.softGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _AchievementBadge(icon: Icons.verified_user_rounded, label: 'Verified'),
        _AchievementBadge(icon: Icons.speed_rounded, label: 'Fast'),
        _AchievementBadge(icon: Icons.emoji_events_rounded, label: 'Top 1%'),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AchievementBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColors.warmMist,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.goldAccent),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _ProfileSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          child: Padding(padding: const EdgeInsets.all(16.0), child: child),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.professionalBlue),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  final String role;
  final String company;
  final String period;

  const _ExperienceItem({
    required this.role,
    required this.company,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.business_center_rounded, color: AppColors.softGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  company,
                  style: const TextStyle(
                    color: AppColors.softGrey,
                    fontSize: 13,
                  ),
                ),
                Text(
                  period,
                  style: const TextStyle(
                    color: AppColors.softGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileFeature extends StatelessWidget {
  const _ProfileFeature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.blueMist,
          child: Icon(icon, color: AppColors.primaryNavy),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status,
              style: const TextStyle(
                color: AppColors.goldAccent,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class _GoldBadge extends StatelessWidget {
  const _GoldBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.goldAccent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryNavy,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.blueMist,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.professionalBlue),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _Requirement extends StatelessWidget {
  final String text;

  const _Requirement({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.emerald,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  final String title;
  final String subtitle;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blueMist,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.professionalBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.goldAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.title, required this.active});

  final String title;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          active
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: active ? AppColors.emerald : AppColors.softGrey,
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) {
    const metrics = [
      ('142', 'Applicants'),
      ('37', 'Shortlisted'),
      ('18', 'Interviews'),
      ('4.8', 'Quality score'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.$1,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.professionalBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(metric.$2),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CandidateRow extends StatelessWidget {
  const _CandidateRow({
    required this.name,
    required this.role,
    required this.score,
  });

  final String name;
  final String role;
  final String score;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: AppColors.warmMist,
        child: Icon(Icons.person_rounded, color: AppColors.primaryNavy),
      ),
      title: Text(name),
      subtitle: Text(role),
      trailing: Text(
        score,
        style: const TextStyle(
          color: AppColors.emerald,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TechChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

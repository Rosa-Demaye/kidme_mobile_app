import 'package:flutter/material.dart';

import '../core/models/kidme_profile.dart';
import '../core/services/kidme_backend_scope.dart';
import '../features/chat/screens/conversation_list_screen.dart';
import '../features/jobs/models/job_model.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/job_card.dart';
import '../widgets/kidme_logo.dart';
import 'login_screen.dart';

class JobFeedScreen extends StatefulWidget {
  const JobFeedScreen({super.key});

  @override
  State<JobFeedScreen> createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends State<JobFeedScreen> {
  int _tabIndex = 0;
  Future<List<Job>>? _jobsFuture;
  Future<KidmeProfile?>? _profileFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = KidmeBackendScope.of(context);
    _jobsFuture ??= service.getJobs();
    _profileFuture ??= service.getCurrentProfile();
  }

  Future<void> _logout() async {
    await KidmeBackendScope.of(context).signOut();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KidmeProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        final profile = snapshot.data ?? _guestProfile;
        final destinations = _destinationsFor(profile);
        final pages = _pagesFor(profile);
        final safeIndex = _tabIndex.clamp(0, pages.length - 1).toInt();

        return Scaffold(
          body: SafeArea(child: pages[safeIndex]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: safeIndex,
            onDestinationSelected: (index) => setState(() => _tabIndex = index),
            destinations: destinations,
          ),
          floatingActionButton: safeIndex == 0
              ? FloatingActionButton.extended(
                  onPressed: () {},
                  backgroundColor: AppColors.goldAccent,
                  foregroundColor: AppColors.primaryNavy,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(profile.isJobSeeker ? 'Apply' : 'Post job'),
                )
              : null,
        );
      },
    );
  }

  List<Widget> _pagesFor(KidmeProfile profile) {
    if (profile.isCompany) {
      return [
        CompanyDashboard(profile: profile, onLogout: _logout),
        const RecruitmentCenterPage(),
        const ApplicantManagementPage(companyMode: true),
        const AnalyticsPage(),
        CompanySettingsPage(profile: profile, onLogout: _logout),
      ];
    }
    if (profile.isPrivateEmployer) {
      return [
        EmployerDashboard(profile: profile, onLogout: _logout),
        const JobManagementPage(),
        const ApplicantManagementPage(),
        const ConversationListScreen(),
        EmployerSettingsPage(profile: profile, onLogout: _logout),
      ];
    }
    return [
      JobSeekerDashboard(
        profile: profile,
        jobsFuture: _jobsFuture!,
        onLogout: _logout,
      ),
      const ApplicationsPage(),
      const ConversationListScreen(),
      const NotificationsScreen(),
      JobSeekerProfilePage(profile: profile, onLogout: _logout),
    ];
  }

  List<NavigationDestination> _destinationsFor(KidmeProfile profile) {
    if (profile.isCompany) {
      return const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        NavigationDestination(icon: Icon(Icons.hub_outlined), label: 'Recruitment'),
        NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Applicants'),
        NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'Analytics'),
        NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
      ];
    }
    if (profile.isPrivateEmployer) {
      return const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        NavigationDestination(icon: Icon(Icons.work_outline_rounded), label: 'Jobs'),
        NavigationDestination(icon: Icon(Icons.people_outline_rounded), label: 'Applicants'),
        NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Messages'),
        NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
      ];
    }
    return const [
      NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.timeline_rounded), label: 'Applications'),
      NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Messages'),
      NavigationDestination(icon: Icon(Icons.notifications_none_rounded), label: 'Notifications'),
      NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
    ];
  }
}

class JobSeekerDashboard extends StatelessWidget {
  const JobSeekerDashboard({
    super.key,
    required this.profile,
    required this.jobsFuture,
    required this.onLogout,
  });

  final KidmeProfile profile;
  final Future<List<Job>> jobsFuture;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: jobsFuture,
      builder: (context, snapshot) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          children: [
            _TopBar(profile: profile, onLogout: onLogout),
            const SizedBox(height: 18),
            _HeroPanel(
              eyebrow: 'Verified career path',
              title: 'How close are you to getting a job?',
              subtitle:
                  'Your trust score rises when ID, diplomas, skills, and documents are verified.',
              action: 'Complete profile',
              icon: Icons.auto_graph_rounded,
            ),
            const SizedBox(height: 16),
            const _MetricGrid(
              metrics: [
                ('85%', 'Profile completion', Icons.task_alt_rounded),
                ('12', 'Applications', Icons.send_rounded),
                ('2', 'Interviews', Icons.event_available_rounded),
                ('34', 'Profile views', Icons.visibility_outlined),
              ],
            ),
            const SizedBox(height: 16),
            const _TrustScoreCard(title: 'Candidate Trust Score', score: 92),
            const SizedBox(height: 16),
            _AiOpportunityRecommendations(profile: profile),
            const SizedBox(height: 16),
            const _SectionHeader(title: 'Home feed', action: 'View all'),
            const _OpportunityRail(),
            const SizedBox(height: 16),
            if (snapshot.connectionState == ConnectionState.waiting)
              const Center(child: CircularProgressIndicator())
            else
              ...(snapshot.data ?? []).map(
                (job) => JobCard(
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
                ),
              ),
          ],
        );
      },
    );
  }
}

class EmployerDashboard extends StatelessWidget {
  const EmployerDashboard({super.key, required this.profile, required this.onLogout});

  final KidmeProfile profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        _TopBar(profile: profile, onLogout: onLogout),
        const SizedBox(height: 18),
        const _HeroPanel(
          eyebrow: 'Private employer',
          title: 'Hire trusted people without complexity.',
          subtitle:
              'Post jobs, review applicants, message candidates, and stay inside safe posting limits.',
          action: 'Create job',
          icon: Icons.storefront_rounded,
        ),
        const SizedBox(height: 16),
        const _MetricGrid(
          metrics: [
            ('4', 'Active jobs', Icons.work_rounded),
            ('58', 'Applicants', Icons.groups_rounded),
            ('7', 'Interviews', Icons.event_rounded),
            ('3', 'Jobs closed', Icons.check_circle_rounded),
          ],
        ),
        const SizedBox(height: 16),
        const _SectionHeader(title: 'Candidate recommendations', action: 'Search'),
        const _CandidateList(),
        const SizedBox(height: 16),
        const _VerificationPanel(
          title: 'Employer verification',
          items: ['National ID', 'Selfie verification', 'Business legitimacy'],
        ),
      ],
    );
  }
}

class CompanyDashboard extends StatelessWidget {
  const CompanyDashboard({super.key, required this.profile, required this.onLogout});

  final KidmeProfile profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        _TopBar(profile: profile, onLogout: onLogout),
        const SizedBox(height: 18),
        const _HeroPanel(
          eyebrow: 'Company HR system',
          title: 'Recruitment command center.',
          subtitle:
              'Manage recruiters, analytics, ATS stages, company branding, and verified documents.',
          action: 'Open ATS',
          icon: Icons.apartment_rounded,
        ),
        const SizedBox(height: 16),
        const _MetricGrid(
          metrics: [
            ('12', 'Open positions', Icons.work_history_outlined),
            ('416', 'Applications', Icons.inbox_outlined),
            ('38', 'Interviews', Icons.calendar_month_rounded),
            ('9', 'Offers sent', Icons.handshake_outlined),
          ],
        ),
        const SizedBox(height: 16),
        const _TrustScoreCard(title: 'Company Trust Score', score: 96),
        const SizedBox(height: 16),
        const AnalyticsPreview(),
        const SizedBox(height: 16),
        const AdminVerificationPanel(),
      ],
    );
  }
}

class JobSeekerProfilePage extends StatelessWidget {
  const JobSeekerProfilePage({super.key, required this.profile, required this.onLogout});

  final KidmeProfile profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Candidate profile',
      onLogout: onLogout,
      children: const [
        _VerificationPanel(
          title: 'Verification status',
          items: ['Identity pending', 'Degree verified', 'Certificates pending'],
        ),
        _SettingsGroup(
          title: 'Personal information',
          items: ['First name', 'Last name', 'Gender', 'Date of birth', 'Phone', 'City', 'Nationality'],
        ),
        _SettingsGroup(
          title: 'Professional information',
          items: ['Current occupation', 'Years of experience', 'Skills', 'Languages', 'Certifications'],
        ),
        _SettingsGroup(
          title: 'Documents',
          items: ['CV / resume', 'Cover letter', 'Diplomas', 'Certificates', 'ID front/back'],
        ),
        _SettingsGroup(title: 'Security', items: ['Password', '2FA', 'Login devices']),
      ],
    );
  }
}

class EmployerSettingsPage extends StatelessWidget {
  const EmployerSettingsPage({super.key, required this.profile, required this.onLogout});

  final KidmeProfile profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Employer profile',
      onLogout: onLogout,
      children: const [
        _SettingsGroup(
          title: 'Employer information',
          items: ['Full name', 'Business name', 'Industry', 'Address', 'Occupation'],
        ),
        _VerificationPanel(
          title: 'Verification',
          items: ['ID verification', 'Selfie verification', 'Business verification'],
        ),
        _SettingsGroup(title: 'Billing', items: ['Subscription plan', 'Payment history']),
        _SettingsGroup(
          title: 'Recruiter preferences',
          items: ['Preferred candidate level', 'Preferred location'],
        ),
      ],
    );
  }
}

class CompanySettingsPage extends StatelessWidget {
  const CompanySettingsPage({super.key, required this.profile, required this.onLogout});

  final KidmeProfile profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Company settings',
      onLogout: onLogout,
      children: const [
        _SettingsGroup(
          title: 'Company profile',
          items: ['Company name', 'Industry', 'Address', 'Website', 'Company email'],
        ),
        _VerificationPanel(
          title: 'Legal documents',
          items: ['RCCM', 'NIF', 'Business license', 'Company stamp', 'Official letter'],
        ),
        _SettingsGroup(
          title: 'Recruiter management',
          items: ['HR manager', 'Recruiter', 'Director', 'Permissions'],
        ),
        _SettingsGroup(title: 'Subscription & billing', items: ['Current plan', 'Invoice history', 'Payment methods']),
      ],
    );
  }
}

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'My applications',
      children: const [
        _StatusLane(title: 'Pending', count: 4, color: AppColors.goldAccent),
        _StatusLane(title: 'Under review', count: 5, color: AppColors.royalViolet),
        _StatusLane(title: 'Shortlisted', count: 2, color: AppColors.emerald),
        _StatusLane(title: 'Rejected', count: 1, color: AppColors.coral),
        _StatusLane(title: 'Accepted', count: 0, color: AppColors.primaryNavy),
        _SettingsGroup(title: 'Saved jobs', items: ['NGO operations assistant', 'Flutter developer', 'Finance intern']),
      ],
    );
  }
}

class JobManagementPage extends StatelessWidget {
  const JobManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimplePage(
      title: 'Job management',
      children: [
        _SettingsGroup(title: 'Create and manage jobs', items: ['Draft job', 'Active jobs', 'Paused jobs', 'Closed jobs']),
        _VerificationPanel(title: 'Posting rights', items: ['Post jobs', 'Review applicants', 'Contact candidates', 'Limited quota']),
      ],
    );
  }
}

class ApplicantManagementPage extends StatelessWidget {
  const ApplicantManagementPage({super.key, this.companyMode = false});

  final bool companyMode;

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: companyMode ? 'Applicant dashboard' : 'Applicants',
      children: const [
        _CandidateList(),
        _SettingsGroup(title: 'Filters', items: ['Experience', 'Education', 'Skills', 'Location']),
      ],
    );
  }
}

class RecruitmentCenterPage extends StatelessWidget {
  const RecruitmentCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimplePage(
      title: 'Recruitment center',
      children: [
        _SettingsGroup(title: 'Company structure', items: ['Departments', 'Recruiters', 'Hiring managers']),
        _SettingsGroup(title: 'ATS stages', items: ['New applicant', 'Screening', 'Interview', 'Assessment', 'Offer', 'Hired', 'Rejected']),
        _SettingsGroup(title: 'Company page', items: ['Logo', 'Banner', 'About us', 'Website', 'Social media']),
        _SettingsGroup(title: 'Talent pool', items: ['Saved candidates', 'Future openings']),
      ],
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimplePage(title: 'Analytics', children: [AnalyticsPreview()]);
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.profile, required this.onLogout});

  final KidmeProfile profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const KidmeLogo(),
        const Spacer(),
        Chip(
          label: Text(profile.accountType),
          avatar: Icon(
            profile.isCompany
                ? Icons.apartment_rounded
                : profile.isPrivateEmployer
                    ? Icons.storefront_rounded
                    : Icons.school_rounded,
            size: 16,
          ),
          backgroundColor: AppColors.softMint,
          side: BorderSide.none,
        ),
        IconButton(
          onPressed: onLogout,
          icon: const Icon(Icons.logout_rounded),
          tooltip: 'Logout',
        ),
      ],
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.action,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final String action;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [AppColors.midnightNavy, AppColors.royalViolet, AppColors.deepGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.royalViolet.withAlpha(45),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GoldBadge(text: eyebrow),
            const SizedBox(height: 18),
            Icon(icon, color: Colors.white, size: 42),
            const SizedBox(height: 14),
            Text(
              title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                  ),
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Color(0xE6FFFFFF), height: 1.45)),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(action),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.goldAccent,
                foregroundColor: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<(String, String, IconData)> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return _AnimatedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(metric.$3, color: AppColors.royalViolet),
              const SizedBox(height: 8),
              Text(metric.$1, style: Theme.of(context).textTheme.headlineSmall),
              Text(metric.$2),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedCard extends StatelessWidget {
  const _AnimatedCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Card(child: Padding(padding: const EdgeInsets.all(16), child: child)),
    );
  }
}

class _TrustScoreCard extends StatelessWidget {
  const _TrustScoreCard({required this.title, required this.score});

  final String title;
  final int score;

  @override
  Widget build(BuildContext context) {
    return _AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_rounded, color: AppColors.emerald),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
              Text('$score/100', style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 10,
              backgroundColor: AppColors.softMint,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emerald),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityRail extends StatelessWidget {
  const _OpportunityRail();

  @override
  Widget build(BuildContext context) {
    const items = [
      'Jobs',
      'Internships',
      'Scholarships',
      'Training',
      'Mentoring',
      'Entrepreneurship',
      'Volunteering',
      'Funding',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          Chip(
            label: Text(item),
            avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.cardBorder),
          ),
      ],
    );
  }
}

class _AiOpportunityRecommendations extends StatelessWidget {
  const _AiOpportunityRecommendations({required this.profile});

  final KidmeProfile profile;

  @override
  Widget build(BuildContext context) {
    final opportunities = _recommendedOpportunities(profile);

    return _AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.royalViolet, AppColors.deepGreen],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI opportunity matches',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Text(
                      'Recommended from your profile, verification, skills, and location.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 192,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: opportunities.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final opportunity = opportunities[index];
                return _OpportunityMatchCard(opportunity: opportunity);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityMatchCard extends StatelessWidget {
  const _OpportunityMatchCard({required this.opportunity});

  final _OpportunityMatch opportunity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: opportunity.color.withAlpha(18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: opportunity.color.withAlpha(70)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: opportunity.color,
                foregroundColor: Colors.white,
                child: Icon(opportunity.icon, size: 20),
              ),
              const Spacer(),
              Text(
                '${opportunity.match}% match',
                style: TextStyle(
                  color: opportunity.color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            opportunity.type,
            style: const TextStyle(
              color: AppColors.softGrey,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            opportunity.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              opportunity.reason,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('View'),
          ),
        ],
      ),
    );
  }
}

class _OpportunityMatch {
  const _OpportunityMatch({
    required this.type,
    required this.title,
    required this.reason,
    required this.match,
    required this.icon,
    required this.color,
  });

  final String type;
  final String title;
  final String reason;
  final int match;
  final IconData icon;
  final Color color;
}

List<_OpportunityMatch> _recommendedOpportunities(KidmeProfile profile) {
  final location = profile.location ?? "N'Djamena";
  final headline = profile.displayHeadline.toLowerCase();
  final isTechProfile =
      headline.contains('flutter') || headline.contains('tech');

  return [
    _OpportunityMatch(
      type: 'Jobs',
      title: isTechProfile ? 'Junior Flutter Developer' : 'Operations Assistant',
      reason: 'Strong fit for your profile strength, location in $location, and verified documents.',
      match: isTechProfile ? 96 : 91,
      icon: Icons.work_rounded,
      color: AppColors.primaryNavy,
    ),
    const _OpportunityMatch(
      type: 'Internships',
      title: 'Digital operations internship',
      reason: 'Good next step for early-career growth and practical experience.',
      match: 89,
      icon: Icons.school_rounded,
      color: AppColors.royalViolet,
    ),
    const _OpportunityMatch(
      type: 'Scholarships',
      title: 'Professional certificate scholarship',
      reason: 'Recommended because certificates can increase your trust score.',
      match: 84,
      icon: Icons.workspace_premium_rounded,
      color: AppColors.goldAccent,
    ),
    const _OpportunityMatch(
      type: 'Training',
      title: 'Microsoft Office and CV readiness',
      reason: 'Training selected to strengthen common employer requirements.',
      match: 87,
      icon: Icons.menu_book_rounded,
      color: AppColors.emerald,
    ),
    const _OpportunityMatch(
      type: 'Mentoring',
      title: 'Career mentor for first interviews',
      reason: 'Mentoring can improve interview readiness and application quality.',
      match: 82,
      icon: Icons.diversity_3_rounded,
      color: AppColors.coral,
    ),
    const _OpportunityMatch(
      type: 'Entrepreneurship',
      title: 'Youth business starter program',
      reason: 'Suggested for candidates open to self-employment and small business support.',
      match: 78,
      icon: Icons.lightbulb_outline_rounded,
      color: AppColors.deepGreen,
    ),
    const _OpportunityMatch(
      type: 'Volunteering',
      title: 'NGO field volunteer opportunity',
      reason: 'Build references while gaining professional field experience.',
      match: 81,
      icon: Icons.volunteer_activism_rounded,
      color: AppColors.jade,
    ),
    const _OpportunityMatch(
      type: 'Funding',
      title: 'Youth skills micro-grant',
      reason: 'Funding recommendation for certificates, transport, and job-readiness expenses.',
      match: 76,
      icon: Icons.savings_rounded,
      color: AppColors.royalViolet,
    ),
  ];
}

class _VerificationPanel extends StatelessWidget {
  const _VerificationPanel({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return _AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final item in items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.pending_actions_rounded, color: AppColors.goldAccent),
              title: Text(item),
              trailing: const Text('Review', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
        ],
      ),
    );
  }
}

class AdminVerificationPanel extends StatelessWidget {
  const AdminVerificationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const _VerificationPanel(
      title: 'Admin verification dashboard',
      items: [
        'Candidate identity, degree, certificates',
        'Employer identity and business legitimacy',
        'Company RCCM, NIF, license, representative',
        'Approve jobs, suspend accounts, handle reports',
      ],
    );
  }
}

class AnalyticsPreview extends StatelessWidget {
  const AnalyticsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsGroup(
      title: 'Recruitment analytics',
      items: ['Applications per job', 'Hiring rate', 'Time-to-hire', 'Most viewed jobs'],
    );
  }
}

class _CandidateList extends StatelessWidget {
  const _CandidateList();

  @override
  Widget build(BuildContext context) {
    return const _SettingsGroup(
      title: 'Verified candidates',
      items: ['Amina Mahamat - Trust score 96', 'Oumar Ali - Trust score 91', 'Grace Ngarlem - Trust score 88'],
    );
  }
}

class _SettingsScaffold extends StatelessWidget {
  const _SettingsScaffold({
    required this.title,
    required this.children,
    required this.onLogout,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineSmall)),
            FilledButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _SimplePage extends StatelessWidget {
  const _SimplePage({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return _AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final item in items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.softMint,
                child: Icon(Icons.check_rounded, size: 17, color: AppColors.emerald),
              ),
              title: Text(item),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
        ],
      ),
    );
  }
}

class _StatusLane extends StatelessWidget {
  const _StatusLane({required this.title, required this.count, required this.color});

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _AnimatedCard(
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withAlpha(32), child: Text('$count', style: TextStyle(color: color))),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        TextButton(onPressed: () {}, child: Text(action)),
      ],
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
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
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
      appBar: AppBar(title: const Text('Job description')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _HeroPanel(
            eyebrow: job.status,
            title: job.role,
            subtitle: '${job.company} - ${job.location} - ${job.salary}',
            action: 'Apply now',
            icon: Icons.work_rounded,
          ),
          const SizedBox(height: 18),
          Text('About the role', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            job.description ??
                'Join a trusted organization hiring through Kidme. Complete your verified profile before applying to improve your candidate trust score.',
          ),
          const SizedBox(height: 18),
          const _VerificationPanel(
            title: 'Trust badges',
            items: ['Verified employer', 'Degree checks preferred', 'Scam report protection'],
          ),
        ],
      ),
    );
  }
}

final _guestProfile = KidmeProfile(
  id: 'guest',
  email: 'guest@kidme.td',
  fullName: 'Kidme Candidate',
  role: 'Job Seeker',
  headline: 'Verified graduate - Open to work',
);

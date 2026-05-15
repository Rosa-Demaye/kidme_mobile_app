import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/kidme_button.dart';
import '../../../widgets/kidme_card.dart';
import '../../../widgets/kidme_logo.dart';
import '../../jobs/screens/job_feed_screen.dart';
import 'login_screen.dart';

/// The [RegisterScreen] allows users to create a new account in the Kidme ecosystem.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _supabaseService = SupabaseService();
  
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nniController = TextEditingController();
  
  int _selectedRole = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nniController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _fullNameController.text.trim();
    final nni = _nniController.text.trim();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _supabaseService.signUp(
        email: email,
        password: password,
        metadata: {
          'full_name': fullName,
          'nni': nni,
          'role': _selectedRole == 0 ? 'candidate' : 'employer',
        },
      );

      if (mounted) {
        // Show success message and navigate
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Check your email for verification.')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const JobFeedScreen(),
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Row(
              children: [
                const KidmeLogo(),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    ),
                  ),
                  child: const Text('Sign in'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _RegisterHero(selectedRole: _selectedRole),
            const SizedBox(height: 18),
            KidmeCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create account',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Start with secure account details, then complete the ONAPE-ready profile.',
                  ),
                  const SizedBox(height: 16),
                  _RoleSelector(
                    selectedRole: _selectedRole,
                    onChanged: (value) => setState(() => _selectedRole = value),
                  ),
                  const SizedBox(height: 18),
                  _AuthField(
                    label: 'Full name',
                    icon: Icons.person_outline_rounded,
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 12),
                  _AuthField(
                    label: 'Email address',
                    icon: Icons.mail_outline_rounded,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  _AuthField(
                    label: 'Password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 12),
                  _AuthField(
                    label: 'National Identity Number (NNI)',
                    icon: Icons.badge_outlined,
                    controller: _nniController,
                  ),
                  const SizedBox(height: 18),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    KidmeButton(
                      label: 'Create account',
                      icon: Icons.verified_user_outlined,
                      onPressed: _handleRegister,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _DocumentReadinessCard(),
          ],
        ),
      ),
    );
  }
}

class _RegisterHero extends StatelessWidget {
  const _RegisterHero({required this.selectedRole});

  final int selectedRole;

  @override
  Widget build(BuildContext context) {
    final roleLabel = selectedRole == 0 ? 'candidate' : 'organization';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavy, AppColors.professionalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.professionalBlue.withAlpha(38),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(31),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withAlpha(51)),
            ),
            child: const Text(
              'Supabase-ready mobile flow',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Join Kidme as a $roleLabel.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'A premium recruitment experience for job seekers, companies, NGOs, and institutions in Chad.',
            style: TextStyle(color: Color(0xDDEFFFFF), height: 1.45),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: _HeroMetric(value: '4', label: 'profile steps'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _HeroMetric(value: '3', label: 'documents'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.selectedRole, required this.onChanged});

  final int selectedRole;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment<int>(
          value: 0,
          label: Text('Candidate'),
          icon: Icon(Icons.person_search_rounded),
        ),
        ButtonSegment<int>(
          value: 1,
          label: Text('Employer'),
          icon: Icon(Icons.business_center_rounded),
        ),
      ],
      selected: {selectedRole},
      onSelectionChanged: (values) => onChanged(values.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryNavy;
          }
          return AppColors.blueMist;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return AppColors.primaryNavy;
        }),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.icon,
    required this.controller,
    this.obscureText = false,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}

class _DocumentReadinessCard extends StatelessWidget {
  const _DocumentReadinessCard();

  @override
  Widget build(BuildContext context) {
    return KidmeCard(
      color: const Color(0xFFFBFDFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColors.warmMist,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.folder_copy_outlined,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Application kit',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Text(
                '0/3',
                style: TextStyle(
                  color: AppColors.professionalBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _DocumentRow(title: 'Diploma PDF', subtitle: 'Education proof'),
          const _DocumentRow(
            title: 'National ID PDF',
            subtitle: 'Identity verification',
          ),
          const _DocumentRow(
            title: 'Criminal record',
            subtitle: 'Less than 6 months old',
          ),
        ],
      ),
    );
  }
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.radio_button_unchecked_rounded,
            color: AppColors.softGrey,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(subtitle),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file_rounded, size: 18),
            label: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.goldAccent,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

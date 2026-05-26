import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/kidme_button.dart';

class CVBuilderScreen extends StatefulWidget {
  const CVBuilderScreen({super.key});

  @override
  State<CVBuilderScreen> createState() => _CVBuilderScreenState();
}

class _CVBuilderScreenState extends State<CVBuilderScreen> {
  bool _isGenerating = false;

  void _generateCV() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI CV generated successfully! Exporting to PDF...'),
          backgroundColor: AppColors.emerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI CV Builder'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryNavy, AppColors.emerald],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.goldAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'AI-Powered Professional CV',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We will use your profile data, experiences, and verified skills to create an ATS-friendly CV.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Included Data',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            const _DataCheckItem(
              title: 'Verified Personal Info',
              isChecked: true,
            ),
            const _DataCheckItem(title: 'Work Experience', isChecked: true),
            const _DataCheckItem(
              title: 'Education & Certifications',
              isChecked: true,
            ),
            const _DataCheckItem(
              title: 'Key Skills & Gap Analysis',
              isChecked: true,
            ),
            const _DataCheckItem(
              title: 'Language Proficiency',
              isChecked: true,
            ),
            const SizedBox(height: 48),
            if (_isGenerating)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'AI is optimizing your content...',
                      style: TextStyle(color: AppColors.softGrey),
                    ),
                  ],
                ),
              )
            else
              KidmeButton(
                label: 'Generate CV',
                icon: Icons.description_rounded,
                onPressed: _generateCV,
              ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Available in French, English, and Arabic',
                style: TextStyle(fontSize: 12, color: AppColors.softGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataCheckItem extends StatelessWidget {
  final String title;
  final bool isChecked;

  const _DataCheckItem({required this.title, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            isChecked
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: isChecked ? AppColors.emerald : AppColors.softGrey,
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

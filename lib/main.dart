import 'package:flutter/material.dart';

import 'screens/job_feed_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const KidmeApp());
}

class KidmeApp extends StatelessWidget {
  const KidmeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kidme',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const JobFeedScreen(),
    );
  }
}

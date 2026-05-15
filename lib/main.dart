import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://aelwijmnnbbjzhamfulb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFlbHdpam1ubmJianpoYW1mdWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0NjMzMTIsImV4cCI6MjA4ODAzOTMxMn0.tjhsl0KOzBxw0rZrHHzzCkevSJ5bjia17JQizVKPqSE',
  );

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
      home: const SplashScreen(),
    );
  }
}

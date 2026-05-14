import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/screens/register_screen.dart';
import 'theme/app_theme.dart';

/// Entry point of the Kidme Mobile Application.
///
/// This file handles the global initialization of services like Supabase
/// and sets up the root [KidmeApp] widget.
Future<void> main() async {
  // Ensure Flutter framework is fully initialized before using platform channels.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with project credentials.
  // URL: https://aelwijmnnbbjzhamfulb.supabase.co
  await Supabase.initialize(
    url: 'https://aelwijmnnbbjzhamfulb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFlbHdpam1ubmJianpoYW1mdWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0NjMzMTIsImV4cCI6MjA4ODAzOTMxMn0.tjhsl0KOzBxw0rZrHHzzCkevSJ5bjia17JQizVKPqSE',
  );

  runApp(const KidmeApp());
}

/// The root widget of the Kidme application.
///
/// Configures the global [MaterialApp] with the professional theme system,
/// routing, and initial screen settings.
class KidmeApp extends StatelessWidget {
  const KidmeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kidme',
      debugShowCheckedModeBanner: false,
      // Apply the centralized light theme defined in AppTheme.
      theme: AppTheme.light,
      // The application starts on the Registration screen to onboard new users.
      home: const RegisterScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/kidme_backend_scope.dart';
import 'core/services/supabase_service.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://aelwijmnnbbjzhamfulb.supabase.co',
  );
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFlbHdpam1ubmJianpoYW1mdWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0NjMzMTIsImV4cCI6MjA4ODAzOTMxMn0.tjhsl0KOzBxw0rZrHHzzCkevSJ5bjia17JQizVKPqSE',
  );

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const KidmeApp());
}

class KidmeApp extends StatelessWidget {
  const KidmeApp({super.key, this.supabaseService});

  final SupabaseService? supabaseService;

  @override
  Widget build(BuildContext context) {
    return KidmeBackendScope(
      service: supabaseService ?? SupabaseService(),
      child: MaterialApp(
        title: 'Kidme',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/jobs/models/job_model.dart';

/// A centralized service to handle all Supabase interactions.
///
/// This service abstracts the data fetching logic from the UI,
/// ensuring that schema changes in the colleague's database
/// can be managed in one place without "crashing" the app.
class SupabaseService {
  final _client = Supabase.instance.client;

  /// Fetches the list of active job postings.
  Future<List<Job>> getJobs() async {
    try {
      // Fallback/Mock data for development consistency:
      await Future.delayed(const Duration(milliseconds: 800));
      return const [
        Job(
          id: '1',
          company: 'Fale Tech',
          role: 'Flutter Mobile Developer',
          location: "N'Djamena",
          salary: '350k-550k XAF',
          match: 96,
          status: 'New',
        ),
        Job(
          id: '2',
          company: 'UNICEF Chad',
          role: 'Monitoring Assistant',
          location: 'Abeche',
          salary: 'Contract',
          match: 91,
          status: 'Verified',
        ),
        Job(
          id: '3',
          company: 'Design Lab',
          role: 'Junior UI/UX Designer',
          location: 'Remote',
          salary: '250k-420k XAF',
          match: 88,
          status: 'Interview',
        ),
      ];
    } catch (e) {
      debugPrint('SupabaseService Error: $e');
      return [];
    }
  }

  /// Handles user registration with Supabase Auth.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> metadata,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }

  /// Handles user sign in with Supabase Auth.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Handles user sign out.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

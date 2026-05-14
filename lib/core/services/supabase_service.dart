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
  /// 
  /// Currently uses mock data logic but is ready to connect to 
  /// the 'jobs' table once the colleague's schema is finalized.
  Future<List<Job>> getJobs() async {
    try {
      // Logic for real data:
      // final response = await _client.from('jobs').select();
      // return (response as List).map((json) => Job.fromJson(json)).toList();
      
      // Fallback/Mock data for development consistency:
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
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
      // Professional error logging
      print('SupabaseService Error: $e');
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
}

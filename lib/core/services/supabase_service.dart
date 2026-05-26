import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/jobs/models/job_model.dart';

/// Centralized service for Supabase interactions.
class SupabaseService {
  final _client = Supabase.instance.client;

  /// Fetches the list of jobs.
  Future<List<Job>> getJobs() async {
    try {
      // For now, returning mock data to maintain UI consistency
      // while the backend schema is being finalized by your colleague.
      await Future.delayed(const Duration(milliseconds: 600));
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
      return [];
    }
  }

  /// Fetches application tracking data.
  Future<List<Map<String, dynamic>>> getApplicationTracker() async {
    // This will eventually fetch from the 'applications' table.
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {'title': 'Profile reviewed', 'active': true},
      {'title': 'Recruiter shortlisted you', 'active': true},
      {'title': 'Interview invitation', 'active': false},
    ];
  }
}

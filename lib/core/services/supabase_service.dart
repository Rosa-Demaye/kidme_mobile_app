import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/jobs/models/job_model.dart';

/// Centralized service for Supabase interactions.
class SupabaseService {
  SupabaseClient get client => Supabase.instance.client;

  /// Fetches the list of jobs with added local categories and verification.
  Future<List<Job>> getJobs() async {
    try {
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
          company: 'Esso Chad',
          role: 'Field Engineer',
          location: 'Doba',
          salary: '800k-1.2M XAF',
          match: 75,
          status: 'Oil & Mining',
        ),
        Job(
          id: '4',
          company: 'Moov Africa',
          role: 'Network Administrator',
          location: "N'Djamena",
          salary: 'Negotiable',
          match: 82,
          status: 'Telecom',
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  /// Fetches application tracking data.
  Future<List<Map<String, dynamic>>> getApplicationTracker() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {'title': 'Applied', 'active': true},
      {'title': 'Viewed by Recruiter', 'active': true},
      {'title': 'Shortlisted', 'active': true},
      {'title': 'Interview Scheduled', 'active': false},
      {'title': 'Accepted', 'active': false},
    ];
  }

  /// Fetches career learning content.
  Future<List<Map<String, String>>> getLearningHubContent() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      {
        'title': 'How to ace an ONAPE interview',
        'category': 'Interview Tips',
        'url': 'https://kidme.td/tips/interview',
      },
      {
        'title': 'Top skills for oil & gas in Chad',
        'category': 'Career Roadmap',
        'url': 'https://kidme.td/tips/oil-mining',
      },
      {
        'title': 'Writing an ATS-friendly CV for NGOs',
        'category': 'CV Tips',
        'url': 'https://kidme.td/tips/cv-ngo',
      },
    ];
  }

  /// Fetches achievement badges for the user.
  Future<List<Map<String, dynamic>>> getUserBadges() async {
    return [
      {'label': 'Verified Graduate', 'icon': 'verified'},
      {'label': 'Fast Responder', 'icon': 'speed'},
      {'label': 'Interview Expert', 'icon': 'school'},
    ];
  }
}

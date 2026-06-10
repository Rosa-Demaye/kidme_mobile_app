import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/jobs/models/job_model.dart';
import '../models/kidme_profile.dart';

/// Centralized service for Supabase Auth, Database, and Storage interactions.
class SupabaseService {
  static const profileTable = 'profiles';
  static const jobPostsTable = 'job_posts';
  static const profileMediaBucket = 'profile-media';

  SupabaseClient get client => Supabase.instance.client;

  User? get currentUser => client.auth.currentUser;

  bool get isSignedIn => currentUser != null;

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await client.auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  Future<KidmeProfile> signUpWithPassword({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? recruiterType,
    String? nationalIdentityNumber,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final metadata = <String, dynamic>{
      'full_name': fullName.trim(),
      'role': role,
    };
    if (recruiterType != null) {
      metadata['recruiter_type'] = recruiterType;
    }
    if (nationalIdentityNumber != null) {
      metadata['national_identity_number'] = nationalIdentityNumber.trim();
    }

    final response = await client.auth.signUp(
      email: normalizedEmail,
      password: password,
      data: metadata,
    );

    final user = response.user ?? currentUser;
    if (user == null) {
      throw const AuthException('Unable to create the Kidme account.');
    }

    final profile = KidmeProfile(
      id: user.id,
      email: normalizedEmail,
      fullName: fullName.trim(),
      role: role,
      recruiterType: recruiterType,
      nationalIdentityNumber: nationalIdentityNumber?.trim(),
      headline: recruiterType == 'Company'
          ? 'Company HR team - Verified hiring'
          : recruiterType == 'Private Employer'
              ? 'Private employer - Hiring locally'
              : 'Verified graduate - Open to work',
      location: "N'Djamena, Chad",
    );

    try {
      return await saveProfile(profile);
    } on PostgrestException catch (_) {
      // If email confirmation is enabled, Supabase may return a user without
      // an authenticated session. Metadata still keeps the profile coherent
      // until the user confirms email and signs in.
      if (client.auth.currentSession == null) {
        return profile;
      }
      rethrow;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await client.auth.resetPasswordForEmail(email.trim().toLowerCase());
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<KidmeProfile?> getCurrentProfile() async {
    final user = currentUser;
    if (user == null) {
      return null;
    }

    try {
      final row = await client
          .from(profileTable)
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (row == null) {
        return _profileFromUser(user);
      }
      return KidmeProfile.fromMap(row);
    } on PostgrestException {
      return _profileFromUser(user);
    }
  }

  Future<KidmeProfile> saveProfile(KidmeProfile profile) async {
    final row = await client
        .from(profileTable)
        .upsert(profile.toUpsertMap())
        .select()
        .single();
    return KidmeProfile.fromMap(row);
  }

  Future<KidmeProfile> uploadProfilePhoto({
    required List<int> bytes,
    required String fileName,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw const AuthException('Please sign in before uploading media.');
    }

    final extension = _extensionFor(fileName);
    final path =
        '${user.id}/avatar_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final bucket = client.storage.from(profileMediaBucket);

    await bucket.uploadBinary(
      path,
      Uint8List.fromList(bytes),
      fileOptions: FileOptions(
        upsert: true,
        contentType: _contentTypeFor(extension),
      ),
    );

    final publicUrl = bucket.getPublicUrl(path);
    final currentProfile = await getCurrentProfile() ?? _profileFromUser(user);
    return saveProfile(
      currentProfile.copyWith(
        avatarPath: path,
        avatarUrl: '$publicUrl?v=${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  Future<KidmeProfile> uploadProfileSnapshot(KidmeProfile profile) async {
    final user = currentUser;
    if (user == null) {
      throw const AuthException('Please sign in before syncing profile files.');
    }

    final path = '${user.id}/profile_snapshot.json';
    final payload = {
      ...profile.toUpsertMap(),
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'source': 'kidme_mobile_app',
    };

    await client.storage.from(profileMediaBucket).uploadBinary(
          path,
          Uint8List.fromList(utf8.encode(jsonEncode(payload))),
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'application/json',
          ),
        );

    return saveProfile(profile.copyWith(profileSnapshotPath: path));
  }

  /// Fetches the list of jobs from Supabase, with local fallback for prototypes.
  Future<List<Job>> getJobs() async {
    try {
      final rows = await client
          .from(jobPostsTable)
          .select()
          .order('created_at', ascending: false)
          .limit(30);
      final jobs = rows.map<Job>((row) => Job.fromJson(row)).toList();
      if (jobs.isNotEmpty) {
        return jobs;
      }
    } on Object {
      // Keep the app useful while database tables are being installed.
    }

    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _demoJobs;
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

  KidmeProfile _profileFromUser(User user) {
    final metadata = user.userMetadata ?? {};
    return KidmeProfile(
      id: user.id,
      email: user.email ?? '',
      fullName: metadata['full_name']?.toString() ?? '',
      role: metadata['role']?.toString() ?? 'Job Seeker',
      recruiterType: metadata['recruiter_type']?.toString(),
      nationalIdentityNumber: metadata['national_identity_number']?.toString(),
      headline: metadata['headline']?.toString(),
    );
  }

  String _extensionFor(String fileName) {
    final pieces = fileName.split('.');
    if (pieces.length < 2) {
      return 'jpg';
    }
    return pieces.last.toLowerCase();
  }

  String _contentTypeFor(String extension) {
    return switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }

  static const _demoJobs = [
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
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kidme_mobile_app/core/models/kidme_profile.dart';
import 'package:kidme_mobile_app/core/services/supabase_service.dart';
import 'package:kidme_mobile_app/features/jobs/models/job_model.dart';
import 'package:kidme_mobile_app/main.dart';

void main() {
  testWidgets('Kidme launches with branded splash screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(KidmeApp(supabaseService: _FakeKidmeService()));

    expect(
      find.text('The Smartest Way to Connect Seekers to Recruiters.'),
      findsOneWidget,
    );
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Onboarding reaches role selection and login', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(KidmeApp(supabaseService: _FakeKidmeService()));

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Find Your Dream Career'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Source Top Talent Fast'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('A Career Ecosystem'), findsOneWidget);

    await tester.tap(find.text('Choose my role'));
    await tester.pumpAndSettle();
    expect(find.text('Set Up Your Profile'), findsOneWidget);
    expect(find.text('I am a Recruiter'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('Login opens sign up then dashboard demo', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(KidmeApp(supabaseService: _FakeKidmeService()));
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I am a Job Seeker'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Sign up'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Build a trusted profile'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Full name'),
      'Rosa Demaye',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Email address'),
      'rosa@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'secure123',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'National Identity Number'),
      '1234567890',
    );

    final createButton = find.widgetWithText(ElevatedButton, 'Create Account');
    await tester.dragUntilVisible(
      createButton,
      find.byType(ListView),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(find.text('Find serious work faster.'), findsOneWidget);
    expect(find.text('Flutter Mobile Developer'), findsOneWidget);
  });
}

class _FakeKidmeService extends SupabaseService {
  KidmeProfile? _profile;

  @override
  bool get isSignedIn => _profile != null;

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    _profile = KidmeProfile(
      id: 'test-user',
      email: email,
      fullName: 'Rosa Demaye',
      role: 'Job Seeker',
      headline: 'Verified graduate - Open to work',
      location: "N'Djamena, Chad",
    );
  }

  @override
  Future<KidmeProfile> signUpWithPassword({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? recruiterType,
    String? nationalIdentityNumber,
  }) async {
    _profile = KidmeProfile(
      id: 'test-user',
      email: email,
      fullName: fullName,
      role: role,
      recruiterType: recruiterType,
      nationalIdentityNumber: nationalIdentityNumber,
      headline: 'Verified graduate - Open to work',
      location: "N'Djamena, Chad",
    );
    return _profile!;
  }

  @override
  Future<KidmeProfile?> getCurrentProfile() async => _profile;

  @override
  Future<KidmeProfile> saveProfile(KidmeProfile profile) async {
    _profile = profile;
    return profile;
  }

  @override
  Future<KidmeProfile> uploadProfileSnapshot(KidmeProfile profile) async {
    _profile = profile.copyWith(profileSnapshotPath: 'test/profile.json');
    return _profile!;
  }

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> signOut() async {
    _profile = null;
  }

  @override
  Future<List<Job>> getJobs() async {
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
    ];
  }
}

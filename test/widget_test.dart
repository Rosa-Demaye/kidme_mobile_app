import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kidme_mobile_app/main.dart';

void main() {
  testWidgets('Kidme launches with branded splash screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const KidmeApp());

    expect(
      find.text('The Smartest Way to Connect Seekers to Recruiters.'),
      findsOneWidget,
    );
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Onboarding reaches role selection and login', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const KidmeApp());

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

    await tester.pumpWidget(const KidmeApp());
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

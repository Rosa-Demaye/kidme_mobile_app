import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kidme_mobile_app/main.dart';

void main() {
  testWidgets('Kidme register screen renders the Figma Make flow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const KidmeApp());

    expect(find.text('Kidme'), findsOneWidget);
    expect(find.text('Join Kidme as a candidate.'), findsOneWidget);
    expect(find.text('Create account'), findsNWidgets(2));

    await tester.scrollUntilVisible(
      find.text('Application kit'),
      420,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Application kit'), findsOneWidget);
  });

  testWidgets('Create account opens the job seeker dashboard demo', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const KidmeApp());

    final createButton = find.widgetWithText(ElevatedButton, 'Create account');

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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kidme_mobile_app/main.dart';

void main() {
  testWidgets('Kidme home renders key product sections', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const KidmeApp());

    expect(find.text('Kidme'), findsOneWidget);
    expect(find.text('Find serious work faster.'), findsOneWidget);
    expect(find.text('Featured jobs'), findsOneWidget);
    expect(find.text('Flutter Mobile Developer'), findsOneWidget);
  });

  testWidgets('Bottom navigation opens recruiter preview', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const KidmeApp());

    await tester.tap(find.text('Recruiter'));
    await tester.pumpAndSettle();

    expect(find.text('Recruiter preview'), findsOneWidget);
    expect(find.text('Top candidates'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p5_spacardo/main.dart';

void main() {
  testWidgets('English demo shell renders', (tester) async {
    await tester.pumpWidget(const P5SpacardoApp());

    // Allow asynchronous initialization without waiting
    // for potentially continuous loading animations.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that either the application shell or
    // its initial loading screen is visible.
    expect(
      find.byType(Scaffold),
      findsWidgets,
    );
  });
}

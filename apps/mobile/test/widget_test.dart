import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p5_spacardo/main.dart';

void main() {
  testWidgets('English demo shell renders', (tester) async {
    await tester.pumpWidget(const P5SpacardoApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('Research prototype'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

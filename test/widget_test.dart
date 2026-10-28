import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hero_widget/main.dart';

void main() {
  testWidgets('Tapping a tile opens the detail page', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const HeroDemoApp());

    // The gallery page should be showing.
    expect(find.text('Hero Gallery'), findsOneWidget);

    // Tap the rocket tile and wait for the Hero animation to finish.
    await tester.tap(find.byIcon(Icons.rocket_launch));
    await tester.pumpAndSettle();

    // The detail page title should now be showing.
    expect(find.text('Rocket'), findsOneWidget);
  });
}
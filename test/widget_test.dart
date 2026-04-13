import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffee_brewing_companion/app.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Use fake async to control time
    await FakeAsync().run((async) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: CoffeeBrewingApp(),
        ),
      );

      // Pump to process animations (not the navigation timer)
      await tester.pump();

      // Verify splash screen shows - look for the coffee icon
      expect(find.byIcon(Icons.coffee_rounded), findsOneWidget);
    });
  });
}

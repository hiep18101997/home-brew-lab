import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffee_brewing_companion/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CoffeeBrewingApp(),
      ),
    );

    // Verify splash screen shows
    expect(find.text('Coffee Brewing'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_brewing_companion/app.dart';
import 'package:coffee_brewing_companion/injection.dart';
import 'package:coffee_brewing_companion/features/beans/presentation/bloc/beans_bloc.dart';
import 'package:coffee_brewing_companion/features/beans/presentation/bloc/beans_event.dart';
import 'package:coffee_brewing_companion/features/brew/presentation/bloc/brew_bloc.dart';
import 'package:coffee_brewing_companion/features/brew/presentation/bloc/brew_event.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await setupDependencies();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<BeansBloc>(create: (_) => getIt<BeansBloc>()..add(BeansRequested())),
          BlocProvider<BrewBloc>(create: (_) => getIt<BrewBloc>()..add(BrewLogsRequested())),
        ],
        child: const CoffeeBrewingApp(),
      ),
    );

    await tester.pump();

    expect(find.text('Coffee Brewing'), findsOneWidget);
  });
}

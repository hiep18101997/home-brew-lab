import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart';
import 'features/beans/presentation/bloc/beans_bloc.dart';
import 'features/beans/presentation/bloc/beans_event.dart';
import 'features/brew/presentation/bloc/brew_bloc.dart';
import 'features/brew/presentation/bloc/brew_event.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BeansBloc>(create: (_) => getIt<BeansBloc>()..add(BeansRequested())),
        BlocProvider<BrewBloc>(create: (_) => getIt<BrewBloc>()..add(BrewLogsRequested())),
      ],
      child: const CoffeeBrewingApp(),
    ),
  );
}

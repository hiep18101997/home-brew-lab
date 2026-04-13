import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/beans/bean_list_screen.dart';
import 'presentation/screens/beans/bean_detail_screen.dart';
import 'presentation/screens/beans/add_bean_screen.dart';
import 'presentation/screens/brew/new_brew_screen.dart';
import 'presentation/screens/brew/brew_timer_screen.dart';
import 'presentation/screens/brew/brew_history_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/beans', builder: (_, __) => const BeanListScreen()),
    GoRoute(path: '/beans/add', builder: (_, __) => const AddBeanScreen()),
    GoRoute(path: '/beans/:id', builder: (context, state) => BeanDetailScreen(id: state.pathParameters['id']!)),
    GoRoute(path: '/brew', builder: (_, __) => const NewBrewScreen()),
    GoRoute(path: '/brew/timer', builder: (_, __) => const BrewTimerScreen()),
    GoRoute(path: '/brew/history', builder: (_, __) => const BrewHistoryScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
  ],
);

class CoffeeBrewingApp extends StatelessWidget {
  const CoffeeBrewingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Coffee Brewing Companion',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark, // Dark mode default
      routerConfig: _router,
    );
  }
}

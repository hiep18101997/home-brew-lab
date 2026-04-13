import 'package:get_it/get_it.dart';
import 'database.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // TODO: Register data sources, repositories, use cases, and BLoCs
  // as each layer is implemented in subsequent tasks
}
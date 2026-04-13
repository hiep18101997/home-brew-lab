import 'package:get_it/get_it.dart';
import 'database.dart';
import 'features/beans/data/datasources/beans_drift_datasource.dart';
import 'features/beans/data/repositories/bean_repository_impl.dart';
import 'domain/repositories/bean_repository.dart';
import 'features/beans/domain/usecases/get_beans.dart';
import 'features/beans/domain/usecases/create_bean.dart';
import 'features/beans/domain/usecases/delete_bean.dart';
import 'features/beans/presentation/bloc/beans_bloc.dart';
import 'features/brew/data/datasources/brew_logs_drift_datasource.dart';
import 'features/brew/data/repositories/brew_repository_impl.dart';
import 'domain/repositories/brew_repository.dart';
import 'features/brew/domain/usecases/get_brew_logs.dart';
import 'features/brew/domain/usecases/create_brew_log.dart';
import 'features/brew/domain/usecases/delete_brew_log.dart';
import 'features/brew/presentation/bloc/brew_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Data Sources
  getIt.registerLazySingleton<BeansDriftDataSource>(
    () => BeansDriftDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<BrewLogsDriftDataSource>(
    () => BrewLogsDriftDataSource(getIt<AppDatabase>()),
  );

  // Repositories
  getIt.registerLazySingleton<BeanRepository>(
    () => BeanRepositoryImpl(getIt<BeansDriftDataSource>()),
  );
  getIt.registerLazySingleton<BrewRepository>(
    () => BrewRepositoryImpl(getIt<BrewLogsDriftDataSource>()),
  );

  // Use Cases - Beans
  getIt.registerFactory(() => GetBeans(getIt<BeanRepository>()));
  getIt.registerFactory(() => CreateBean(getIt<BeanRepository>()));
  getIt.registerFactory(() => DeleteBean(getIt<BeanRepository>()));

  // Use Cases - Brew
  getIt.registerFactory(() => GetBrewLogs(getIt<BrewRepository>()));
  getIt.registerFactory(() => CreateBrewLog(getIt<BrewRepository>()));
  getIt.registerFactory(() => DeleteBrewLog(getIt<BrewRepository>()));

  // BLoCs
  getIt.registerFactory(() => BeansBloc(
    getBeans: getIt<GetBeans>(),
    createBean: getIt<CreateBean>(),
    deleteBean: getIt<DeleteBean>(),
  ));
  getIt.registerFactory(() => BrewBloc(
    getBrewLogs: getIt<GetBrewLogs>(),
    createBrewLog: getIt<CreateBrewLog>(),
    deleteBrewLog: getIt<DeleteBrewLog>(),
  ));
}
